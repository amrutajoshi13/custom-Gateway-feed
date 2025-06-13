#!/bin/sh

. /lib/functions.sh

Sim2DataFile="/etc/sim2data"
TmpSim2DataFile="/tmp/sim2data"
Sim2DataFlagFile="/etc/sim2dataflag"

                                       
NMS_Enable=$(uci get remoteconfig.nms.nmsenable)
mwan3status=$(uci get mwan3config.general.select)

                                                               
if [ -f "$TmpSim2DataFile" ]                                            
then              
   echo 0 > "$TmpSim2DataFile"                                         
fi

if [ -f "$Sim2DataFile" ]                                            
then
   flash_data_used=`cat "$Sim2DataFile"` 
   num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)                         
   echo "0,$num_writes_full,0" > "$Sim2DataFile"                                           
fi                            

if [ -f "$Sim2DataFlagFile" ] 
then
   echo 0 > "$Sim2DataFlagFile" 
fi

IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)
OpenvpnEnable=$(uci get vpnconfig1.general.enableopenvpngeneral)                              

/etc/init.d/mwan3 stop
/root/InterfaceManager/script/SimSwitch.sh CWAN1 2
sleep 4

sleep 10
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
/bin/sleep 1                                                                                                                  
/etc/init.d/ipsec start                                                                                                       
/bin/sleep 4                                                                                                                  
/usr/sbin/ipsec restart                                                                                                       
fi 
if [ "$OpenvpnEnable" = "1" ] ; then                             
   /etc/init.d/openvpn restart                                      
fi
if [ "$NMS_Enable" = "1" ]
then
/etc/init.d/openvpn restart
fi 
[ ! -f /tmp/InterfaceStatus/CWAN1_1Status ] && touch /tmp/InterfaceStatus/CWAN1_1Status                                  
echo "`date` Interface CWAN1_0 DOWN" >> /tmp/InterfaceStatus/CWAN1_1Status  
echo "Sim Switch"

if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
then
	/usr/sbin/mwan3 restart > /dev/null 2>&1
	/bin/sleep 2
elif [ "$mwan3status" = "none" ] 
then
    mwan3 stop
fi
