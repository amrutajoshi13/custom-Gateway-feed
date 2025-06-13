#!/bin/sh

. /lib/functions.sh

Openvpnmain="/bin/openvpngeneral.sh"
mwan3status=$(uci get mwan3config.general.select)

ReadSystemConfigFile()
{
   	config_load "$SystemConfigFile"
   	config_get CellularOperationModelocal sysconfig CellularOperationMode
   	config_get EnableCellular sysconfig enablecellular
   	config_get Service sysconfig service
   	config_get Sim2Service sysconfig sim2service
   	 config_get SmsEnable1 smsconfig smsenable1
        config_get SmsEnable2 smsconfig smsenable2
        config_get Wifi1Mode wificonfig wifi1mode
   	
}


ReadSystemGpioFile()
{
   	config_load "$SystemGpioConfig"
	config_get SimSelectGpio gpio simselectgpio
	config_get Sim1SelectValue gpio sim1selectvalue
	config_get Sim2SelectValue gpio sim2selectvalue
}

swlaninterface="SW_LAN"
lan1interface="LAN1"
lan2interface="LAN2"
lan3interface="LAN3"
lan4interface="LAN4"
ethwan1interface="EWAN1"
ethwan2interface="EWAN2"
cellularwan1interface="CWAN1"
cellularwan2interface="CWAN2"
cellularwan3interface="CWAN3"
cellularwan1sim1interface="CWAN1_0"
cellularwan1sim2interface="CWAN1_1"
wifiap="WIFI"
wifista="WIFI_WAN"

SystemGpioConfig="/etc/config/systemgpio"
SystemConfigFile="/etc/config/sysconfig"

MwanConfigFile="/etc/config/mwan3config"

Gcom2Gonly="/etc/gcom/set2gonly.gcom"
Gcom4Gonly="/etc/gcom/set4gonly.gcom"
GcomAutoonly="/etc/gcom/setauto.gcom"

ReadSystemConfigFile
ReadSystemGpioFile


simtmpfile="/tmp/simnumfile"
SimSwitchingGpio="/sys/class/gpio/gpio$SimSelectGpio/value"

Logfile="/root/ConfigFiles/Logs/AddIfaceLog.txt"
Findapn="/root/InterfaceManager/script/findapn.sh"
AutoApnFlag="/root/usrRPC/script/autoapnflag.txt"
model1=$(uci get sysconfig.sysconfig.model1)

#Set APN for sim1
SetAPNSim1()
{
               date=$(date)
		Protocol=$(uci get modem.CWAN1_0.protocol)
		PDP1=$(uci get sysconfig.sysconfig.pdp)
		username=$(uci get sysconfig.sysconfig.username)
		password=$(uci get sysconfig.sysconfig.password)
		auth=$(uci get sysconfig.sysconfig.auth)
		Sim1apntype=$(uci get sysconfig.sysconfig.Sim1apntype)
		Sim2apntype=$(uci get sysconfig.sysconfig.Sim2apntype)
		if [ -z "$username" ]
		then
			username=""
			password=""
        else
			username=$username
			password=$password
        fi
		auth=$auth
		if [ "$PDP1" = "IPV4" ] 
		then
				PDPN=1
			  	PDP_QMI=IP
		elif [ "$PDP1" = "IPV6" ] 
		then
				PDPN=2
			  	PDP_QMI=IPV6
		elif [ "$PDP1" = "IPV4V6" ] 
		then
			  PDPN=3
			  PDP_QMI=IPV4V6
		fi
		
		InterfaceName=CWAN1_0
        if [ $InterfaceName = "CWAN1_0" ] || [ $InterfaceName = "CWAN1" ] 
		then
		    if [ $Sim1apntype = "auto" ] 
		    then
				echo "SETAPN=1" > "$AutoApnFlag"
				echo "$Sim1SelectValue" > "$SimSwitchingGpio"
				source /tmp/InterfaceManager/status/ports.txt
				/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh $ComPort
				sleep 20
				response=$($Findapn  $InterfaceName)  /dev/null 2>&1
				sleep 5
				echo "SETAPN=0" > "$AutoApnFlag"
				APN=$(uci get sysconfig.sysconfig.sim1autoapn)
         	       #source /tmp/InterfaceManager/status/ATComport.txt	
		    elif [ $Sim1apntype = "manual" ]
		    then
		     		APN=$(uci get sysconfig.sysconfig.apn)
		    fi
		fi
		
		
		if [ "$Protocol" = "cdcether" ]
		then
		    for i in 1 2 3 4 5 6                                                                                     
			do
			   Status=$(/bin/at-cmd /dev/ttyUSB$i AT+QICSGP=1,"$PDPN",\"$APN\",\"$username\",\"$password\","$auth" | awk NR==2 | tr -d '\011\012\013\014\015\040')                           
				if [ "$Status" = "OK" ]                                                                                 
				then
				    /bin/at-cmd /dev/ttyUSB$i AT+QIDEACT=1
				    echo "$date:[SystemRestart script]APN set Successfully for sim1 ,APN=$APN,PDP=$PDPN" >> "$Logfile"
				    break
				fi
		    done
		    if [ "$Status" != "OK" ]                                                                                 
				then
				    /bin/at-cmd /dev/ttyUSB$i AT+QIDEACT=1
				    echo "$date:[SystemRestart script]Status is not ok for APN and PDP AT command in sim1,APN=$APN,PDP=$PDPN,comport=$ComPort,username=$username,password=$password,auth=$auth" >> "$Logfile"
				    /bin/at-cmd /dev/ttyUSB$i AT+QIDEACT=1
				    break
			fi
		    
		elif [ "$Protocol" = "qmi" ]
		then
			for i in 1 2                                                                                         
			do
				Status=$(/bin/at-cmd /dev/ttyUSB$i AT+CGDCONT=1,\"$PDP_QMI\",\"$APN\","","","" | awk NR==2 | tr -d '\011\012\013\014\015\040') 
			    if [ "$Status" = "OK" ]                                                                                 
				then
				    echo "$date:[SystemRestart script]APN set Successfully for sim1" >> "$Logfile"
				    break
				fi
		    done
		fi
}

#set APN and PDP for sim2 before sim switching
SetAPNSim2()
{
		Protocol=$(uci get modem.CWAN1_1.protocol)
		PDP1=$(uci get sysconfig.sysconfig.sim2pdp)
		username=$(uci get sysconfig.sysconfig.sim2username)
		password=$(uci get sysconfig.sysconfig.sim2password)
		auth=$(uci get sysconfig.sysconfig.sim2auth)
		Sim1apntype=$(uci get sysconfig.sysconfig.Sim1apntype)
		Sim2apntype=$(uci get sysconfig.sysconfig.Sim2apntype)
		if [ -z "$username" ]
		then
			username=""
			password=""
        else
			username=$username
			password=$password
        fi
		auth=$auth
		if [ "$PDP1" = "IPV4" ] 
		then
				PDPN=1
			  	PDP_QMI=IP
		elif [ "$PDP1" = "IPV6" ] 
		then
				PDPN=2
			  	PDP_QMI=IPV6
		elif [ "$PDP1" = "IPV4V6" ] 
		then
			  PDPN=3
			  PDP_QMI=IPV4V6
		fi
		
		InterfaceName=CWAN1_1
		if [ $InterfaceName = "CWAN1_1" ] 
		then
		    if [ $Sim2apntype = "auto" ] 
		    then
				echo "SETAPN=1" > "$AutoApnFlag"
				echo "$Sim2SelectValue" > "$SimSwitchingGpio"
				source /tmp/InterfaceManager/status/ports.txt
				/root/usrRPC/script/Recycle_WAN1_PWR_Script.sh $ComPort
				sleep 20
				response=$($Findapn  $InterfaceName)  /dev/null 2>&1
				sleep 5
				echo "SETAPN=0" > "$AutoApnFlag"
				APN=$(uci get sysconfig.sysconfig.sim2autoapn)
         	       #source /tmp/InterfaceManager/status/ATComport.txt	
		    elif [ $Sim2apntype = "manual" ]
		    then  
		       	APN=$(uci get sysconfig.sysconfig.sim2apn)
		    fi
		fi
		
		if [ "$Protocol" = "cdcether" ]
		then
                      
			for i in 1 2 3 4 5 6                                                                                     
			do
				Status=$(/bin/at-cmd /dev/ttyUSB$i AT+QICSGP=1,"$PDPN",\"$APN\",\"$username\",\"$password\","$auth" | awk NR==2 | tr -d '\011\012\013\014\015\040')                           
		        if [ "$Status" = "OK" ]                                                                                 
				then
				    /bin/at-cmd /dev/ttyUSB$i AT+QIDEACT=1
				    echo "$date:[SystemRestart script]APN set Successfully for sim2 ,APN=$APN,PDP=$PDPN" >> "$Logfile"
				    break
				fi
		    done
		     if [ "$Status" != "OK" ]                                                                                 
				then
				    /bin/at-cmd /dev/ttyUSB$i AT+QIDEACT=1
				    echo "$date:[SystemRestart script]Status is not ok for APN and PDP AT command in sim2,APN=$APN,PDP=$PDPN,comport=$ComPort,username=$username,password=$password,auth=$auth" >> "$Logfile"
				    /bin/at-cmd /dev/ttyUSB$i AT+QIDEACT=1
				    break
			fi
		elif [ "$Protocol" = "qmi" ]
		then

			Status=$(/bin/at-cmd /dev/ttyUSB$i AT+CGDCONT=1,\"$PDP_QMI\",\"$APN\","","","" | awk NR==2 | tr -d '\011\012\013\014\015\040') 
		    if [ "$Status" = "OK" ]                                                                                 
				then
				    echo "$date:[SystemRestart script]APN set Successfully for sim2" >> "$Logfile"
				    break
				fi
		fi
}



if [ "$EnableCellular" = "1" ]
then
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
	then
	  ComPort1=$(cat "/tmp/InterfaceManager/status/$cellularwan1interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
	  ComPort2=$(cat "/tmp/InterfaceManager/status/$cellularwan2interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
	  if [ "$Service" = "auto" ]
	  then
	    /usr/bin/gcom -d "$ComPort1" -s "$GcomAutoonly"
	  elif [ "$Service" = "lte" ]
	  then
	    /usr/bin/gcom -d "$ComPort1" -s "$Gcom4Gonly"
	  else
	    /usr/bin/gcom -d "$ComPort1" -s "$Gcom2Gonly"
	  fi
	  if [ "$Sim2Service" = "auto" ]
	  then
	    /usr/bin/gcom -d "$ComPort2" -s "$GcomAutoonly"
	  elif [ "$Sim2Service" = "lte" ]
	  then
	    /usr/bin/gcom -d "$ComPort2" -s "$Gcom4Gonly"
	  else
	    /usr/bin/gcom -d "$ComPort2" -s "$Gcom2Gonly"
	  fi
	  sleep 5
	  ubus call interfacemanager update {\"interface\":\"$cellularwan1interface\"} 2>&1
	  ubus call interfacemanager update {\"interface\":\"$cellularwan2interface\"} 2>&1
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1sim1interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1sim2interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan2interface"
#	  ubus call interfacemanager recycle {\"interface\":\"$cellularwan1interface\"} 2>&1
#	  ubus call interfacemanager recycle {\"interface\":\"$cellularwan2interface\"} 2>&1
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
	then
	  simnum=$(cat /tmp/simnumfile)                                                                                         
      if [ "$simnum" = "1" ]                                                                                                
      then
        ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1sim1interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
      else
        ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1sim2interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)     
      fi 
      if [ "$Service" = "auto" ]
	  then
	    /usr/bin/gcom -d "$ComPort" -s "$GcomAutoonly"
	  elif [ "$Service" = "lte" ]
	  then
	    /usr/bin/gcom -d "$ComPort" -s "$Gcom4Gonly"
	  else
	    /usr/bin/gcom -d "$ComPort" -s "$Gcom2Gonly"
	  fi  
		source /tmp/InterfaceManager/status/ports.txt
		if [ "$model1" -ne "EM05-G" ]
		then
			  SetAPNSim1
	    fi
	    Protocol=$(uci get modem.CWAN1_0.protocol)
	  [ ! -f "$simtmpfile" ] && touch "$simtmpfile"
	  echo 1 > "$simtmpfile"
	  echo "$Sim1SelectValue" > "$SimSwitchingGpio"
	  sleep 2
	  ubus call interfacemanager update {\"interface\":\"$cellularwan1sim1interface\"}
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1sim1interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1sim2interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan2interface"
#	  ubus call interfacemanager recycle {\"interface\":\"$cellularwan1sim1interface\"} 2>&1
      
	else
      ComPort=$(cat "/tmp/InterfaceManager/status/$cellularwan1sim1interface.ports" | grep -iw "Comport" | cut -d "=" -f 2)
      if [ "$Service" = "auto" ]
	  then
	    /usr/bin/gcom -d "$ComPort" -s "$GcomAutoonly"
	  elif [ "$Service" = "lte" ]
	  then
	    /usr/bin/gcom -d "$ComPort" -s "$Gcom4Gonly"
	  else
	    /usr/bin/gcom -d "$ComPort" -s "$Gcom2Gonly"
	  fi 
	    if [ "$model1" -ne "EM05-G" ]
		then
	  	  SetAPNSim1
	  	fi 
	  echo "$Sim1SelectValue" > "$SimSwitchingGpio"
	  sleep 2
	  ubus call interfacemanager update {\"interface\":\"$cellularwan1interface\"}
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1sim1interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1sim2interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan1interface"
	  /root/InterfaceManager/script/InterfaceInitializer.sh stop "$cellularwan2interface"
#	  ubus call interfacemanager recycle {\"interface\":\"$cellularwan1interface\"} 2>&1
	fi
	/root/InterfaceManager/script/InterfaceInitializer.sh boot
else
	uci delete network."${cellularwan1interface}" > /dev/null 2>&1
	uci delete network."${cellularwan2interface}" > /dev/null 2>&1
	uci delete network."${cellularwan3interface}" > /dev/null 2>&1
	uci delete network."${cellularwan1sim1interface}" > /dev/null 2>&1
	uci delete network."${cellularwan1sim2interface}" > /dev/null 2>&1
	uci commit network
fi

/etc/init.d/dnsmasq restart

/bin/sleep 50 

/etc/init.d/network restart > /dev/null 2>&1


/etc/init.d/firewall restart > /dev/null 2>&1 

/bin/sleep 40

mwan3status=$(uci get mwan3config.general.select)
if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
then
    /etc/init.d/mwan3 start
elif [ "$mwan3status" = "none" ] 
then
      mwan3 stop
fi

if [ "$Wifi1Mode" = "sta" ]
then
     iwpriv ra0 set HideSSID=1
	 iwpriv ra1 set HideSSID=1
fi
#~ IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)


#~ if [ "$IpsecEnable" = "1" ] ; then
#~ /usr/sbin/ipsec restart
#~ else
#~ /usr/sbin/ipsec stop
#~ fi

IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)
OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)

if [ "$IpsecEnable" = "1" ] ; then
     interfac=$(route -n | awk NR==3 | awk '{print $8}')                                                                           
   if [ "$interfac" = "eth0.4" ]                                                                                                 
   then                                                                                                                          
     uci set ipsec.general.interface="EWAN1"                                                                                     
     uci set firewall.ipsec_rule1.src="EWAN1"                                                                                     
     uci set firewall.ipsec_rule2.src="EWAN1"                                                                                     
     uci set firewall.ipsec_rule3.src="EWAN1"                                                                                     
   elif [ "$interfac" = "eth0.5" ]                                                                                               
   then                                                                                                                          
      uci set ipsec.general.interface="EWAN2" 
     uci set firewall.ipsec_rule1.src="EWAN2"                                                                                     
     uci set firewall.ipsec_rule2.src="EWAN2"                                                                                     
     uci set firewall.ipsec_rule3.src="EWAN2" 
   elif [ "$interfac" = "apcli0" ]                                                                                               
   then                                                                                                                          
      uci set ipsec.general.interface="WIFI_WAN" 
     uci set firewall.ipsec_rule1.src="WIFI_WAN"                                                                                     
     uci set firewall.ipsec_rule2.src="WIFI_WAN"                                                                                     
     uci set firewall.ipsec_rule3.src="WIFI_WAN"                                                                                   
   elif [ "$interfac" = "3g-CWAN1" ]                                                                                             
   then                                                                                                                          
      uci set ipsec.general.interface="CWAN1"
     uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
     uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
     uci set firewall.ipsec_rule3.src="CWAN1"                                                                                    
   elif [ "$interfac" = "3g-CWAN2" ]                                                                                             
   then                                                                                                                          
      uci set ipsec.general.interface="CWAN2"  
     uci set firewall.ipsec_rule1.src="CWAN2"                                                                                     
     uci set firewall.ipsec_rule2.src="CWAN2"                                                                                     
     uci set firewall.ipsec_rule3.src="CWAN2"                                                                                    
   elif [ "$interfac" = "3g-CWAN1_0" ]                                                                                           
   then                                                                                                                          
      uci set ipsec.general.interface="CWAN1_0"  
     uci set firewall.ipsec_rule1.src="CWAN1_0"                                                                                     
     uci set firewall.ipsec_rule2.src="CWAN1_0"                                                                                     
     uci set firewall.ipsec_rule3.src="CWAN1_0"                                                                                  
   elif [ "$interfac" = "3g-CWAN1_1" ]                                                                                           
   then                                                                                                                          
      uci set ipsec.general.interface="CWAN1_1" 
     uci set firewall.ipsec_rule1.src="CWAN1_1"                                                                                     
     uci set firewall.ipsec_rule2.src="CWAN1_1"                                                                                     
     uci set firewall.ipsec_rule3.src="CWAN1_1"                                                                                   
   elif [ "$interfac" = "usb0" ]                                                                                                 
   then                                                                                                                          
       if [ "$CellularOperationModelocal" = "singlecellularsinglesim" ]                                                          
       then                                                                                                                      
           uci set ipsec.general.interface="CWAN1" 
            uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
           uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
           uci set firewall.ipsec_rule3.src="CWAN1"                                                                               
       else                                                                                                                      
           simnum=$(cat /tmp/simnumfile)                                                                                         
           if [ "$simnum" = "1" ]                                                                                                
           then                                                                                                                  
             uci set ipsec.general.interface="CWAN1_0"
             uci set firewall.ipsec_rule1.src="CWAN1_0"                                                                                     
             uci set firewall.ipsec_rule2.src="CWAN1_0"                                                                                     
             uci set firewall.ipsec_rule3.src="CWAN1_0"                                                                            
           else                                                                                                                  
             uci set ipsec.general.interface="CWAN1_1"
             uci set firewall.ipsec_rule1.src="CWAN1_1"                                                                                     
             uci set firewall.ipsec_rule2.src="CWAN1_1"                                                                                     
             uci set firewall.ipsec_rule3.src="CWAN1_1"                                                                            
           fi                                                                                                                    
       fi                                                                                                                        
   else                                                                                                                          
       if [ "$CellularOperationModelocal" = "singlecellularsinglesim" ]                                                          
       then                                                                                                                      
           uci set ipsec.general.interface="CWAN1"
           uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
           uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
           uci set firewall.ipsec_rule3.src="CWAN1"                                                                                
       else                                                                                                                      
           simnum=$(cat /tmp/simnumfile)                                                                                         
           if [ "$simnum" = "1" ]                                                                                                
           then                                                                                                                  
             uci set ipsec.general.interface="CWAN1_0" 
             uci set firewall.ipsec_rule1.src="CWAN1_0"                                                                                     
             uci set firewall.ipsec_rule2.src="CWAN1_0"                                                                                     
             uci set firewall.ipsec_rule3.src="CWAN1_0"                                                                           
           else                                                                                                                  
             uci set ipsec.general.interface="CWAN1_1"
             uci set firewall.ipsec_rule1.src="CWAN1_1"                                                                                     
             uci set firewall.ipsec_rule2.src="CWAN1_1"                                                                                     
             uci set firewall.ipsec_rule3.src="CWAN1_1"                                                                            
           fi                                      
         fi                                                                                                                        
    fi                                                                                                                           
    uci commit ipsec
    uci commit firewall
    sleep 1
    /etc/init.d/firewall reload
    
    /etc/init.d/ipsec stop
    /bin/sleep 2                                                                                       
   /etc/init.d/ipsec start                                                                                                       
   /bin/sleep 4                                                                                                                  
   /usr/sbin/ipsec restart                                                                                                       

fi

if [ "$OpenvpnEnable" = "1" ] ; then
response=$($Openvpnmain)
sleep 2
uci set vpnconfig1.general.openvpnrunning=1
uci commit vpnconfig1
else
uci set vpnconfig1.general.openvpnrunning=0
uci commit vpnconfig1
fi

NMS_Enable=$(uci get remoteconfig.nms.nmsenable)

/bin/sleep 2

pid=$(pgrep -f "/root/InterfaceManager/script/SMS_Incomming_event.sh")
kill -TERM "$pid" > /dev/null 2>&1                      
sleep 1                                                 
kill -KILL "$pid" > /dev/null 2>&1
kill -9 "$pid" > /dev/null 2>&1
pid=$(pgrep -f inotifywait)
kill -9 $pid
if [ "${NMS_Enable}" = "1" ]
then
response=$($Openvpnmain)
fi

if [ "$SmsEnable1" = "1" ] || [ "SmsEnable2" = "1" ]
then
  /root/InterfaceManager/script/SMS_Incomming_event.sh &
fi

if [ "$EnableCellular" = "0" ]
then
   sed -i '/Reset_data_usage/d' /etc/crontabs/root
   sed -i '/cellulardatausagemanagerspeedcronscript/d' /etc/crontabs/root
   sed -i '/Data_Cap/d' /etc/crontabs/root
fi
/bin/macidblocking.sh
/bin/routing.sh
if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
then
	/usr/sbin/mwan3 restart > /dev/null 2>&1
	/bin/sleep 2
elif [ "$mwan3status" = "none" ] 
then
    mwan3 stop
fi
exit 0
