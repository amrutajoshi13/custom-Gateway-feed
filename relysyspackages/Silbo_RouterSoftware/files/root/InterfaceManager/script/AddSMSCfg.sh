#!/bin/sh

. /lib/functions.sh

#
# PKG_RELEASE: 1.01
#

#
# Read Modem Configuration file
# 
ReadModemConfigFile()
{
        config_load "$ModemConfigFile"
        config_get DataEnable "$InterfaceName" dataenable
        config_get SMSEnable "$InterfaceName" smsenable1
        config_get ModemEnable "$InterfaceName" modemenable
        config_get SMSCenterNumber "$InterfaceName" smsc
        config_get ConfiguredSMSPort "$InterfaceName" smsport
        config_get ConfiguredDataPort "$InterfaceName" device
        config_get PortType "$InterfaceName" porttype
}

enable_smscenternosim1=$(uci get sysconfig.smsconfig.enable_smscenternosim1)
enable_smscenternosim2=$(uci get sysconfig.smsconfig.enable_smscenternosim2)
#
# Search for SMS port and write the same into file 
#
PortSearch()
{
        if [ "$PortType" = "ttyS" ]
        then
                if [ "x$ConfiguredSMSPort" != "x" ]
                then
                        # Get original/enumerated SMS port 
                        EnmSMSPort="/dev/ttyS""$ConfiguredSMSPort"
                fi
                
                [ -c "$EnmSMSPort" ]  && SMSPort="$EnmSMSPort"
                echo "SMSPort=$SMSPort" > "$PortDetailsFile"
                
                if [ -c "$EnmSMSPort" ]
                then
                        echo "status=Enumerated" >> "$PortDetailsFile"
                else
                        echo "status=Port NE" >> "$PortDetailsFile"
                        echo "status=Disabled" > "$AddSMSCfgStatusFile"
                        exit 1
                fi
        else
                if [ "x$ConfiguredSMSPort" != "x" ]
                then
                        # Add an extra count to port number for searching
                        SearchConfiguredSMSPort=$((ConfiguredSMSPort + 1))
                        # search for symbolically linked ports(generated by udev rule) and copy the same
                        SMSPortSymLink=$(find /dev -maxdepth 1 -name  "$InterfaceName""_"* | sort | sed -n $SearchConfiguredSMSPort"p")
                        # Get original/enumerated sms port
                        [ "x$SMSPortSymLink" != "x" ]  && SMSPortSymLink="$SMSPortSymLink" && EnmSMSPort=$(readlink -f "$SMSPortSymLink")
                fi
                
                echo "SMSPortSymLink=$SMSPortSymLink" > "$PortDetailsFile"
                echo "SMSPort=$EnmSMSPort" >> "$PortDetailsFile"
                
                if [ "x$SMSPortSymLink" = "x" ]
                then
                        echo "status=Disabled" > "$AddSMSCfgStatusFile"
                        echo "status=PortLink NE" >> "$PortDetailsFile"
                        exit 1
                else
                        if [ "x$EnmSMSPort" = "x" ]
                        then
                                echo "status=Disabled" > "$AddSMSCfgStatusFile"
                                echo "status=Port NE" >> "$PortDetailsFile"
                                exit 1
                        else
                                echo "status=Enumerated" >> "$PortDetailsFile"
                        fi
                fi
        fi

}

#
# Delete sms configurations
#
DeleteSMSConfiguration()
{
        # remove Modem settings from sms configuration
        
        # remove modem name from  devices variable
        Devices=$(sed -n "/^\<devices\>/p" "$SMSCfgFile"  | cut -d "=" -f 2 | sed 's/^[ \t]*//;s/[ \t]*$//')
        ModifiedDevices=$(echo "$Devices" | awk  -v awkIfaceName="$InterfaceName" -F', ' '{for (i=1; i<=NF; i++) if ($i !~ awkIfaceName) printf $i","}') 
        if [ "x$ModifiedDevices" = "x" ]         
        then                             
                # deleting values assigned for 'devices' variable
                tmpdevicesline="devices = "
                sed -i 's!\<devices\>.*!'"$tmpdevicesline"'!' "$SMSCfgFile"
        else                                                 
                # update 'devices' variable with new value        
                pdevices=$(echo "$ModifiedDevices" | sed s'/,$//')       
                tmpdevicesline="devices = $pdevices"
                sed -i 's!\<devices\>.*!'"$tmpdevicesline"'!' "$SMSCfgFile"
        fi
        
        # Remove section
        sed -i '/\['"$InterfaceName"'\]/,/'"\#end""$InterfaceName"'/d' "$SMSCfgFile"  > /dev/null 2>&1

        # Remove consecutive blank lines
        sed -i 'N;/^\n$/d;P;D' "$SMSCfgFile" > /dev/null 2>&1
        
}

#
# Add sms configurations and start smsd daemon
#
AddSMSConfiguration()
{
        if [ "$SMSEnable" -ne 1 ]
        then
                echo "status=Disabled" > "$AddSMSCfgStatusFile"
        else
                if [ "$ConfiguredDataPort" = "$ConfiguredSMSPort" ] && [ "$DataEnable" = "1" ]
                then
                        echo "status=Disabled" > "$AddSMSCfgStatusFile"
                else
                        # Add Modem settings to sms configuration
                        # update devices variable
                        Devices=$(sed -n "/^\<devices\>/p" "$SMSCfgFile"  | cut -d "=" -f 2 | sed 's/^[ \t]*//;s/[ \t]*$//')
                        if [ "x$Devices" = "x" ]
                        then
                                tmpdevicesline="devices = $InterfaceName"
                                sed -i 's!\<devices\>.*!'"$tmpdevicesline"'!' "$SMSCfgFile"
                        else
                                if ! echo "$Devices" | grep -iq "$InterfaceName" 
                                then
                                        pdevices="$Devices"",""$InterfaceName"
                                        tmpdevicesline="devices = $pdevices"
                                        sed -i 's!\<devices\>.*!'"$tmpdevicesline"'!' "$SMSCfgFile"
                                fi
                        fi
                
                        # add section
                        {
                                echo "[$InterfaceName]"
                                echo "init = AT+CPMS=\"ME\",\"ME\",\"ME\""
                                echo "device = $EnmSMSPort"
                                echo "incoming = high"
                                echo "baudrate = 115200"
                                if ([ "$enable_smscenternosim1" = "1" ] && [ "$InterfaceName" = "CWAN1_0" ]) || ([ "$enable_smscenternosim1" = "1" ] && [ "$InterfaceName" = "CWAN1" ])
                                then
									echo "smsc = +$SMSCenterNumber"
                                elif ([ "$enable_smscenternosim2" = "1" ] && [ "$InterfaceName" = "CWAN1_1" ]) 
                                then
                                    echo "smsc = +$SMSCenterNumber"
                                fi
                                echo "start = AT+CMGD=1,2"
                                echo "startsleeptime = 2"
                                echo "memory_start = 0"
                                echo "trust_spool = no"
                                echo "device_open_retries = -1"
                                echo "#end""$InterfaceName"
                        } >> "$SMSCfgFile"
                        
                        if [ ! -f "$smsbootfile" ]
                        then
                                # sleep if system is booted
                                sleep "$SleepAfterBoot"
                                # clear modem and sim memory
                                /usr/bin/gcom -d "$EnmSMSPort" -s /etc/deletesms.gcom > /dev/null 2>&1
                                # start smsd
                                echo "[$(date +"%Y-%m-%d %H:%M:%S")] boot file" > "$smsbootfile" 
                                #/etc/init.d/smstools3 start > /dev/null 2>&1
                        else
                               # /etc/init.d/smstools3 start > /dev/null 2>&1
                               echo ""
                        fi
                        echo "status=Enabled" > "$AddSMSCfgStatusFile"
                fi
        fi
}

#
# Delete files in directories.
#
RemoveFiles () {

        SourcePath="$1"
        MaxNoSMS="$2"
        
        # Delete received/sent/failed messages if number of messages exceeds max limit
        TotalFiles=$(find "$SourcePath" -maxdepth 1 -type f -exec "$statCmd" -c "%i" {} \; | wc -l)
        if [ "$TotalFiles" -gt "$MaxNoSMS" ]
        then
                FilesToRemove=$(($TotalFiles - $MaxNoSMS))
                
                echo "*** deleting files in directory $SourcePath ***"
                for i in $(find "$SourcePath" -maxdepth 1 -type f -exec "$statCmd" --printf "%Y\t%i\n" {} \; | sort -n | head -n"$FilesToRemove" | cut -f 2)
                do
                        find "$SourcePath" -inum "$i" -exec rm {} \;
                done
        fi
        
        return 0
}

#
# Input arguments and Default Parameters
#
InterfaceName="$1"
ModemConfigFile="/etc/config/modem"
ScriptStatustDir="/tmp/InterfaceManager/status"
ScriptLogDir="/tmp/InterfaceManager/log"
PortDetailsFile="$ScriptStatustDir/$InterfaceName"".smsport"
AddSMSCfgStatusFile="$ScriptStatustDir/$InterfaceName"".AddSMSCfgStatus"
DeleteSMSCfgStatusFile="$ScriptStatustDir/$InterfaceName"".DeleteSMSCfgStatus"
lockfile="/var/run/$InterfaceName""AddSMSCfg.lockfile"
SMSCfgFile="/etc/smsd.conf"
smsbootfile="$ScriptLogDir/smsbootfile"
SleepForEnumerationOfAllPorts=2
SleepAfterBoot=30
OutgoingSMSDir="/root/sms/outgoing/"
MaxOutgoingSMS=20
statCmd="/usr/bin/stat"

[ -d "$ScriptStatustDir" ]  || mkdir -p "$ScriptStatustDir"
[ -d "$ScriptLogDir" ]  || mkdir -p "$ScriptLogDir"

#
# verify input arguments
#
if [ "x$InterfaceName" = "x" ]
then
    echo "Usage: $0 InterfaceName"
    echo "status=Invalid interface" > "$AddSMSCfgStatusFile"
    exit 1
fi

#
# 
#
if (set -o noclobber; echo $$ > "$lockfile") 2> /dev/null
then
        trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT
        sleep "$SleepForEnumerationOfAllPorts"
        ReadModemConfigFile
       # /etc/init.d/smstools3 stop > /dev/null 2>&1
        DeleteSMSConfiguration
        RemoveFiles "$OutgoingSMSDir" "$MaxOutgoingSMS"
        if [ "$ModemEnable" -ne 1 ]
        then
                rm -f "$PortDetailsFile"
                rm -f "$AddSMSCfgStatusFile"
                exit 0
        fi
        rm -f "$DeleteSMSCfgStatusFile"
        PortSearch
        AddSMSConfiguration
        rm -f "$lockfile"
        trap - INT TERM EXIT
fi

exit 0
