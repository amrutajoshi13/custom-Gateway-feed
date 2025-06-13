#!/bin/sh

#
# PKG_RELEASE: 1.01
#

#
# Input and default parameters
#
InterfaceName="$1"
VendorId="$2"
ProductId="$3"
PortType="$4"
HotplugUSBBusPath="$5"
HotplugRulesFileDir="/etc/hotplug.d/tty"
StatusFileDir="/tmp/InterfaceManager/status/"
CallUbusInterfaceManager="/root/InterfaceManager/script/CallUbusInterfaceManager.sh"
Savedfile=`echo $InterfaceName | cut -d '_' -f1`
HotplugRulesFileName1="${HotplugRulesFileDir}/01-${Savedfile}"
HotplugRulesFileName2="${HotplugRulesFileDir}/02-${Savedfile}"
StatusFile="${StatusFileDir}${InterfaceName}.HotplugRuleStatus"
SymLinkPrefix="${InterfaceName}_"
ModemConfigFile="/etc/config/modem"


[ -d "$StatusFileDir" ] || mkdir "$StatusFileDir"
[ -d "$HotplugRulesFileDir" ] || mkdir "$HotplugRulesFileDir"

#
# verify input arguments
#
if [ "x$InterfaceName" = "x" ] || [ "x$VendorId" = "x" ] || [ "x$ProductId" = "x" ] || [ "x$PortType" = "x" ] || [ "x$HotplugUSBBusPath" = "x" ]
then
    echo "status=input parameter error" > "$StatusFile"
    exit 1
fi

#
# assign usb bus to interface
#

#
# write Hotplug rule
#
{
    echo "#!/bin/sh"
    echo -e "\n"
    echo "[ \"\${ACTION}\" = \"add\" ] || [ \"\${ACTION}\" = \"remove\" ] || exit 0"
    echo -e "\n"
    echo ". /lib/functions.sh"
    echo -e "\n"
    echo "ReadModemConfigFile()"
    echo "{"
    echo -e "\tconfig_load \"\$ModemConfigFile\""
    echo -e "\tconfig_get SingleSimSingleModule \"cellularmodule\" singlesimsinglemodule"
    echo -e "\tconfig_get SingleSimDualModule \"cellularmodule\" singlesimdualmodule"
    echo -e "\tconfig_get DualSimSingleModule \"cellularmodule\" dualsimsinglemodule"
    echo "}"
    echo -e "\n"
    echo "[ \${DEVNAME/[0-9]/} = \"$PortType\" ] || exit 0"
    echo -e "\n"    

    echo "devdir=\"/sys\${DEVPATH}/../../../../\""
    echo "mVid=\$(cat \"\$devdir/idVendor\")"
    echo "mPid=\$(cat \"\$devdir/idProduct\")"
    echo -e "\n"

    echo "ModemConfigFile=\"/etc/config/modem\""
    echo "SimNumFile=\"/tmp/simnumfile\""
    echo -e "\n"

    echo "ReadModemConfigFile"

    echo -e "path=\$(echo \$DEVPATH | cut -d '/' -f 7 | cut -d ':' -f 1)"


    echo -e "if [ \"\$path\" = \"$HotplugUSBBusPath\" ]"
    echo -e "then"
    
    echo -e "\n" 
    
    echo "str=\${DEVNAME}"
    echo "if [ \"\$DualSimSingleModule\" = \"1\" ]"
    echo "then"
    echo -e "\tif [ ! -f \"\$SimNumFile\" ]"
    echo "then"
    echo -e "\t\ttouch \"\$SimNumFile\""
    echo -e "\t\techo \"1\" > \"\$SimNumFile\""
    echo -e "\t\tuci set modem.${Savedfile}_0.modemenable=1"
    echo -e "\t\tuci set modem.${Savedfile}_1.modemenable=0"
    echo -e "\t\tuci set modem.${Savedfile}.modemenable=0"
    echo -e "\t\tuci commit modem"
    echo -e "\t\t\t\tprefix=\"${Savedfile}_0_\""
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_\""
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\"" 
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}"
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_1_\""
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\""                                                                                                    
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}" 
    echo -e "\telse"
    echo -e "\t\tsim=\`cat \"\$SimNumFile\"\`"
    echo -e "\t\tif [ \"\$sim\" = \"1\" ]"
    echo -e "\t\tthen"
    echo -e "\t\t\tuci set modem.${Savedfile}_0.modemenable=1"
    echo -e "\t\t\tuci set modem.${Savedfile}_1.modemenable=0"
    echo -e "\t\t\tuci set modem.${Savedfile}.modemenable=0"
    echo -e "\t\t\tuci commit modem"
    echo -e "\t\tprefix=\"${Savedfile}_0_\""
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_\""
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\""                                                                                                    
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}"                                                                                                     
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_1_\""
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\""                                                                                                 
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}"  
    echo -e "\t\telse"
    echo -e "\t\t\tuci set modem.${Savedfile}_0.modemenable=0"                                                                                          
    echo -e "\t\t\tuci set modem.${Savedfile}_1.modemenable=1"                                                                                          
    echo -e "\t\t\tuci set modem.${Savedfile}.modemenable=0"                                                                                            
    echo -e "\t\t\tuci commit modem"
    echo -e "\t\tprefix=\"${Savedfile}_1_\""
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_\""
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\""                                                                                                   
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}"                                                                                                     
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_0_\""
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\""                                                                                                 
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}"  
    echo -e "\t\tfi"
    echo -e "\tfi"
    echo "else"
    echo -e "\t\tuci set modem.${Savedfile}_0.modemenable=0"                                                                                            
    echo -e "\t\tuci set modem.${Savedfile}_1.modemenable=0"                                                                                            
    echo -e "\t\tuci set modem.${Savedfile}.modemenable=1"
    echo -e "\t\t\tuci commit modem"
    echo -e "\t\tprefix=\"${Savedfile}_\""
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_0_\""
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\""                                                                                                   
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}"                                                                                                     
    echo -e "\t\t\tprefixlocal=\"${Savedfile}_1_\"" 
    echo -e "\t\t\tSYMLINKLOCAL=\"\${prefixlocal}\$(echo -n \${str} | tail -c 1)\""                                                                                                
    echo -e "\t\t\trm /dev/\${SYMLINKLOCAL}"  
    echo "fi"
    echo -e "\n"

    echo "SYMLINK=\"\${prefix}\$(echo -n \${str} | tail -c 1)\""

    echo "logger devpath=\$DEVPATH action=\$ACTION devname=\$DEVNAME symlink=\$SYMLINK vendorid=\$mVid Productid=\$mPid product=\$PRODID type=\$HOTPLUG_TYPE"
    echo -e "\n"

    echo "if [ \"\${ACTION}\" = \"add\" ]"
    echo "then"
    echo -e "\tif [ \"${VendorId}\" = \"\${mVid}\" ] && [ \"${ProductId}\" = \"\${mPid}\" ]"
    echo -e "\tthen"
    echo -e "\t\tln -s /dev/\${DEVNAME} /dev/\${SYMLINK}"
    echo -e "\t\tlogger -t modem Symlink from /dev/\$DEVNAME to /dev/\${SYMLINK} created"
    echo -e "\tfi"
    echo "elif [ \"x\${mVid}\" = \"x\" ] && [ \"\${ACTION}\" = \"remove\" ]"
    echo "then"
    echo -e "\trm /dev/\${SYMLINK}"
    echo -e "\tlogger -t modem Symlink /dev/\${SYMLINK} removed"
    echo "fi"
    echo "fi"
} > ${HotplugRulesFileName1}

chmod +x ${HotplugRulesFileName1}
{
    echo "#!/bin/sh"
    echo -e "\n"
    echo "[ \"\${ACTION}\" = \"add\" ] || [ \"\${ACTION}\" = \"remove\" ] || exit 0"
    echo -e "\n"
    echo ". /lib/functions.sh"                                                                                                                  
    echo -e "\n"
    echo "SystemGpioConfig=\"/etc/config/systemgpio\""
	echo -e "\n"
    echo "ReadModemConfigFile()"                                                                                                                
    echo "{"                                                                                                                                    
    echo -e "\tconfig_load \"\$ModemConfigFile\""                                                                                                  
    echo -e "\tconfig_get SingleSimSingleModule "cellularmodule" singlesimsinglemodule"                                                         
    echo -e "\tconfig_get SingleSimDualModule "cellularmodule" singlesimdualmodule"                                                             
    echo -e "\tconfig_get DualSimSingleModule "cellularmodule" dualsimsinglemodule"                                                             
    echo "}"                                                                                                                                    
    echo -e "\n"
    
        
    echo "ReadSystemGpioFile()"
    echo "{"
    echo -e "\tconfig_load \"\$SystemGpioConfig\""
    echo -e "\tconfig_get Sim1LedGpio gpio Sim1LedGpio"
    echo -e "\tconfig_get Sim1LedGpioOnvalue gpio Sim1LedGpioOnvalue"
    echo -e "\tconfig_get Sim1LedGpioOffvalue gpio Sim1LedGpioOffvalue"
    echo -e "\tconfig_get Sim2LedGpio gpio Sim2LedGpio"
    echo -e "\tconfig_get Sim2LedGpioOnvalue gpio Sim2LedGpioOnvalue"
    echo -e "\tconfig_get Sim2LedGpioOffvalue gpio Sim2LedGpioOffvalue"
    echo "}"
    echo -e "\n"
    echo "ReadSystemGpioFile"
        
    echo "[ \${DEVNAME/[0-9]/} = \"$PortType\" ] || exit 0"
    echo -e "\n"

    echo "devdir=\"/sys\${DEVPATH}/../../../../\""
    echo "mVid=\$(cat \"\$devdir/idVendor\")"
    echo "mPid=\$(cat \"\$devdir/idProduct\")"
    echo -e "\n"
 
    echo "ModemConfigFile="/etc/config/modem""                                                                                                  
    echo "SimNumFile="/tmp/simnumfile""                                                                                                         
    echo -e "\n"                                                                                                                                
                                                                                                                                                
    echo "ReadModemConfigFile"


   echo -e "path=\$(echo \$DEVPATH | cut -d '/' -f 7 | cut -d ':' -f 1)"

    echo -e "if [ \"\$path\" = \"$HotplugUSBBusPath\" ]"
    echo -e "then"                                                                                                                 
    echo -e "\n"    

    echo "str=\${DEVNAME}"
    echo "if [ \"\$DualSimSingleModule\" = \"1\" ]"                                                                                                  
    echo "then"                                                                                                                                 
    echo -e "\tif [ ! -f \"\$SimNumFile\" ]"                                                                                                       
    echo "then"                                                                                                                                 
    echo -e "\t\ttouch \"\$SimNumFile\""                                                                                                           
    echo -e "\t\techo \"1\" > \"\$SimNumFile\""                                                                                                        
    echo -e "\t\tuci set modem.${Savedfile}_0.modemenable=1"                                                                                           
    echo -e "\t\tuci set modem.${Savedfile}_1.modemenable=0"                                                                                           
    echo -e "\t\tuci set modem.${Savedfile}.modemenable=0"                                                                                             
    echo -e "\t\tuci commit modem"
    echo -e "\t\tprefix=${Savedfile}_0_"
    echo -e "\telse"                                                                                                                            
    echo -e "\t\tsim=\`cat \"\$SimNumFile\"\`"                                                                                                       
    echo -e "\t\tif [ \"\$sim\" = \"1\" ]"                                                                                                             
    echo -e "\t\tthen"                                                                                                                          
    echo -e "\t\t\tuci set modem.${Savedfile}_0.modemenable=1"                                                                                         
    echo -e "\t\t\tuci set modem.${Savedfile}_1.modemenable=0"                                                                                         
    echo -e "\t\t\tuci set modem.${Savedfile}.modemenable=0"                                                                                           
    echo -e "\t\t\tuci commit modem" 
    echo -e "\t\tprefix=${Savedfile}_0_"
    echo -e "\t\telse"                                                                                                                          
    echo -e "\t\t\tuci set modem.${Savedfile}_0.modemenable=0"                                                                                         
    echo -e "\t\t\tuci set modem.${Savedfile}_1.modemenable=1"                                                                                         
    echo -e "\t\t\tuci set modem.${Savedfile}.modemenable=0"                                                                                           
    echo -e "\t\t\tuci commit modem" 
    echo -e  "\t\tprefix=${Savedfile}_1_"
    echo -e "\t\tfi"                                                                                                                            
    echo -e "\tfi"                                                                                                                              
    echo "else"                                                                                                                                 
    echo -e "\t\tuci set modem.${Savedfile}_0.modemenable=0"                                                                                           
    echo -e "\t\tuci set modem.${Savedfile}_1.modemenable=0"                                                                                           
    echo -e "\t\tuci set modem.${Savedfile}.modemenable=1"
    echo -e "\t\t\tuci commit modem"
    echo -e "\t\tprefix=${Savedfile}_" 
    echo "fi"                                                                                                                                   

    echo -e "\n"
    echo "SYMLINK=\"\${prefix}\$(echo -n \${str} | tail -c 1)\""


    echo "if [ \"\${ACTION}\" = \"add\" ]"
    echo "then"
    echo -e "\tif [ \"${VendorId}\" = \"\${mVid}\" ] && [ \"${ProductId}\" = \"\${mPid}\" ]"
    echo -e "\tthen"
    echo -e "\t\tif [ \"\$DualSimSingleModule\" = \"1\" ]"                                                                                             
    echo -e "\t\tthen"                                                                                                                                 
    echo -e "\t\t\tif [ ! -f \"\$SimNumFile\" ]"                                                                                                    
    echo -e "\t\t\tthen"                                                                                                                                 
    echo -e "\t\t\t\ttouch \"\$SimNumFile\""                                                                                                        
    echo -e "\t\t\t\techo \"1\" > \"\$SimNumFile\""  
     
    echo -e "\t\t\t\techo \"1\" > /sys/class/gpio/gpio\"\$Sim2LedGpio\"/value"  
    echo -e "\t\t\t\techo \"0\" > /sys/class/gpio/gpio\"\$Sim1LedGpio\"/value"  
    
                                                                                                       
    echo -e "\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"enable\" \"${Savedfile}_0\" &"                                                                                                        
    echo -e "\t\t\telse"                                                                                                                            
    echo -e "\t\t\t\tsim=\`cat \"\$SimNumFile\"\`"                                                                                                  
    echo -e "\t\t\t\tif [ \"\$sim\" = \"1\" ]"                                                                                                      
    echo -e "\t\t\t\tthen"
    
    echo -e "\t\t\t\techo \"1\" > /sys/class/gpio/gpio\"\$Sim2LedGpio\"/value"  
    echo -e "\t\t\t\techo \"0\" > /sys/class/gpio/gpio\"\$Sim1LedGpio\"/value"   
    
    echo -e "\t\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"enable\" \"${Savedfile}_0\" &"                                                                                                                         
    echo -e "\t\t\t\telse"                                                                                                                          
    echo -e "\t\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"enable\" \"${Savedfile}_1\" &"                                                                                                       
    echo -e "\t\t\t\tfi"
    echo -e "\t\t\t\tfi"                                                                                                                                                                                                                                                         
    echo -e "\t\t\t\telse"
    echo -e "\t\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"enable\" \"${Savedfile}\" &"                                                                                                                                                                                                                                                                    
    echo -e "\t\tfi"
    echo -e "\tfi"
    echo -e "\telif [ \"x\${mVid}\" = \"x\" ] && [ \"\${ACTION}\" = \"remove\" ]"
    echo -e "\tthen"
    echo -e "\t\tif [ \"\$DualSimSingleModule\" = \"1\" ]"                                                                                      
    echo -e "\t\tthen"                                                                                                                          
    echo -e "\t\t\tif [ ! -f \"\$SimNumFile\" ]"                                                                                                
    echo -e "\t\t\tthen"                                                                                                                        
    echo -e "\t\t\t\ttouch \"\$SimNumFile\""                                                                                                    
    echo -e "\t\t\t\techo \"1\" > \"\$SimNumFile\""                                                                                                 
    echo -e "\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"disable\" \"${Savedfile}_0\" &"                                 
    echo -e "\t\t\telse"                                                                                                                        
    echo -e "\t\t\t\tsim=\`cat \"\$SimNumFile\"\`"                                                                                              
    echo -e "\t\t\t\tif [ \"\$sim\" = \"1\" ]"                                                                                                  
    echo -e "\t\t\t\tthen"                                                                                                                      
    echo -e "\t\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"disable\" \"${Savedfile}_0\" &"                               
    echo -e "\t\t\t\telse"                                                                                                                      
    echo -e "\t\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"disable\" \"${Savedfile}_1\" &"                               
    echo -e "\t\t\t\tfi"                                                                                                                        
    echo -e "\t\t\t\tfi"                                                                                                                        
    echo -e "\t\t\t\telse"                                                                                                                      
    echo -e "\t\t\t\t\t/root/InterfaceManager/script/CallUbusInterfaceManager.sh \"disable\" \"${Savedfile}\" &"                                 
    echo -e "\t\tfi"
    echo "fi"
    echo "fi"
} > ${HotplugRulesFileName2}

chmod +x ${HotplugRulesFileName2}
#
# verify the Hotplug rule file
#
if [ -s "$HotplugRulesFileName1" ] 
then
    if [ -s "$HotplugRulesFileName2" ] 
    then
        echo "status=success" > "$StatusFile"
        exit 0
    else
        echo "status=Hotplug $HotplugRulesFileName2 file not created" > "$StatusFile"
        exit 1
    fi
else
    echo "status=Hotplug $HotplugRulesFileName1 file not created" > "$StatusFile"
    exit 1
fi
