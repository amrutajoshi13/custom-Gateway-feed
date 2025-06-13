#!/bin/sh

. /lib/functions.sh

IpsecEnable=$(uci get vpnconfig1.general.enableipsecgeneral)

upstatus=$(ipsec status | grep connecting | awk NR==1 | awk '{ print $3 }' | cut -d "(" -f 2)

CellularOperationModelocal=$(uci get sysconfig.sysconfig.CellularOperationMode)

if [ "$upstatus" -gt "0" ]
then
    echo "Ipsec is Up"
else
     #Get the default ifname from routing table.
     interfac=$(route -n | awk NR==3 | awk '{print $8}')                                                                           
			#Ethernet
			wanCount=$(cat /etc/waninterface.txt | wc -l)
			
			for j in $(seq 1 ${wanCount})
			do		   
				wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)    
			
				#Get the ifname for every interface name
				match_ifname=$(uci get network.$wan.ifname)
				
				#To get the interface name of the default route ifname, match the ifname from waninterface.txt  
				#with the ifname from routing table .
				
				if [ "$match_ifname" = "$interfac" ]
				then
				    interface_name="$wan"	
					break
				fi                    
			done

			if [ -n "$interface_name" ]
			then
				uci set ipsec.general.interface="$interface_name"                                                                                     
				uci set firewall.ipsec_rule1.src="$interface_name"                                                                                     
				uci set firewall.ipsec_rule2.src="$interface_name"                                                                                     
				uci set firewall.ipsec_rule3.src="$interface_name" 
			fi
			
			#STA
			if [ "$interfac" = "apcli0" ]                                                                                               
			then                                                                                                                          
				uci set ipsec.general.interface="WIFI_WAN" 
				uci set firewall.ipsec_rule1.src="WIFI_WAN"                                                                                     
				uci set firewall.ipsec_rule2.src="WIFI_WAN"                                                                                     
				uci set firewall.ipsec_rule3.src="WIFI_WAN"    
			fi
	
	
			if [ "$interfac" = "3g-CWAN1" ]                                       
			then                                                 
				uci set ipsec.general.interface="CWAN1"   
				uci set firewall.ipsec_rule1.src="CWAN1"   
				uci set firewall.ipsec_rule2.src="CWAN1"   
				uci set firewall.ipsec_rule3.src="CWAN1"  
			fi      
		   
			if [ "$interfac" = "3g-CWAN2" ]                    
			then                                         
				uci set ipsec.general.interface="CWAN2"   
				uci set firewall.ipsec_rule1.src="CWAN2"   
				uci set firewall.ipsec_rule2.src="CWAN2"   
				uci set firewall.ipsec_rule3.src="CWAN2"   
			fi
		
			if [ "$interfac" = "3g-CWAN1_0" ]          
			then                                         
				uci set ipsec.general.interface="CWAN1_0" 
				uci set firewall.ipsec_rule1.src="CWAN1_0" 
				uci set firewall.ipsec_rule2.src="CWAN1_0" 
				uci set firewall.ipsec_rule3.src="CWAN1_0" 
			fi
		
			if [ "$interfac" = "3g-CWAN1_1" ]          
			then                                         
				uci set ipsec.general.interface="CWAN1_1" 
				uci set firewall.ipsec_rule1.src="CWAN1_1" 
				uci set firewall.ipsec_rule2.src="CWAN1_1" 
				uci set firewall.ipsec_rule3.src="CWAN1_1" 
			fi
	
			#Cellular
			if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]                                                          
			then
				if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ]
				then
					uci set ipsec.general.interface="CWAN1"
					uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
					uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
					uci set firewall.ipsec_rule3.src="CWAN1"
				fi
				if [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
				then
					uci set ipsec.general.interface="CWAN2"
					uci set firewall.ipsec_rule1.src="CWAN2"                                                                                     
					uci set firewall.ipsec_rule2.src="CWAN2"                                                                                     
					uci set firewall.ipsec_rule3.src="CWAN2"
				fi
			elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]                                                          
			then
				if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ] || [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
				then
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
				if [ "$interfac" = "usb0" ] || [ "$interfac" = "wwan0" ] || [ "$interfac" = "usb1" ] || [ "$interfac" = "wwan1" ]
				then
					uci set ipsec.general.interface="CWAN1"
					uci set firewall.ipsec_rule1.src="CWAN1"                                                                                     
					uci set firewall.ipsec_rule2.src="CWAN1"                                                                                     
					uci set firewall.ipsec_rule3.src="CWAN1"
				fi
			fi
                                                                                                    
    uci commit ipsec
    uci commit firewall
    sleep 1
    /etc/init.d/firewall reload                                                                                                               
    if [ "$IpsecEnable" = "1" ] ; then
   /etc/init.d/ipsec stop
   /bin/sleep 2                                                                                              
   /etc/init.d/ipsec start                                                                                                          
   /bin/sleep 4                                                                                                                     
   /usr/sbin/ipsec restart                                                                                                          
   fi  
fi
