#!/bin/sh

. /lib/functions.sh

ReadSysConfig()
{
  config_load "$sysconfigfile"
  config_get Cellular_Mode sysconfig CellularOperationMode
  config_get Protocol sysconfig protocol1
  config_get EnableCellular sysconfig enablecellular
  #~ config_get Sim1DataLimit sysconfig sim1datausagelimit
  #~ config_get Sim2DataLImit sysconfig sim2datausagelimit
}

mwan3status=$(uci get mwan3config.general.select)

simswitchconfigUCIPath="/etc/config/simswitchconfig"
simswitchconfigsection="simswitchconfig"

config_load "$simswitchconfigUCIPath"
config_get Sim1DataLimit "$simswitchconfigsection" sim1datausagelimit 
config_get Sim2DataLImit "$simswitchconfigsection" sim2datausagelimit

#Data_Threshold=2000
Data_Storage_Threshold=15

sysconfigfile="/etc/config/sysconfig"

ReadSysConfig

SimNumFile="/tmp/simnumfile"
Sim1DataFile="/etc/sim1data"
Sim1DataFlagFile="/etc/sim1dataflag"
TmpSim1DataFile="/tmp/sim1data"
Sim2DataFile="/etc/sim2data"
Sim2DataFlagFile="/etc/sim2dataflag"
TmpSim2DataFile="/tmp/sim2data"
SimDataFile="/etc/simdata"
SimDataFlagFile="/etc/simdataflag"
TmpSimDataFile="/tmp/simdata"

NMS_Enable=$(uci get remoteconfig.nms.nmsenable)

if [ "$EnableCellular" = "1" ]
then
if [ "${Cellular_Mode}" = "singlecellulardualsim" ]
then
		sim=`cat "$SimNumFile"`
		if [ "$sim" = "1" ]
		then
		    if [ ! -f "$TmpSim1DataFile" ]
		    then
		      touch "$TmpSim1DataFile"
		      echo 0 > "$TmpSim1DataFile"
		    fi
    	    if [ ! -f "$Sim1DataFile" ]
            then
                touch "$Sim1DataFile"
                echo "1,1,0" > "$Sim1DataFile"
            fi
			if [ "$Protocol" = "cdcether" ]                           
			then  
			    tx_data=$(cat /sys/class/net/usb0/statistics/tx_bytes)
			    rx_data=$(cat /sys/class/net/usb0/statistics/rx_bytes)
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    tmp_data_used=`cat "$TmpSim1DataFile"`
			    data_difference=`expr $data_used - $tmp_data_used`  
			    if [ $data_difference -ge $Data_Storage_Threshold ]
			    then
			        echo "$data_used" > "$TmpSim1DataFile"
		            flash_data_used=`cat "$Sim1DataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$Sim1DataFile"
				fi
				flash_data_used=`cat "$Sim1DataFile"`
		        flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		        new_flash_data=`expr $flash_data_used + $data_difference`
			    if [ $new_flash_data -ge $Sim1DataLimit ]
	            then
	                /etc/init.d/mwan3 stop
	                if [ ! -f "$Sim1DataFlagFile" ]
					then
					  touch "$Sim1DataFlagFile"
					  echo 1 > "$Sim1DataFlagFile"
					else
					   echo 1 > "$Sim1DataFlagFile"
					fi
	                /root/InterfaceManager/script/SimSwitch.sh CWAN1 2
	                sleep 4
				    [ ! -f /tmp/InterfaceStatus/CWAN1_0Status ] && touch /tmp/InterfaceStatus/CWAN1_0Status                                  
				    echo "`date` Interface CWAN1_0 DOWN" >> /tmp/InterfaceStatus/CWAN1_0Status  
				    echo "Sim Switch"
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
					if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
					then
						/usr/sbin/mwan3 restart > /dev/null 2>&1
						/bin/sleep 2
					elif [ "$mwan3status" = "none" ] 
					then
					    mwan3 stop
					fi
				fi
			elif [ "$Protocol" = "qmi" ]
			then
				tx_data=$(cat /sys/class/net/wwan0/statistics/tx_bytes) 
				rx_data=$(cat /sys/class/net/wwan0/statistics/rx_bytes) 
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    tmp_data_used=`cat "$TmpSim1DataFile"`
			    data_difference=`expr $data_used - $tmp_data_used`  
			    if [ $data_difference -ge $Data_Storage_Threshold ]
			    then
			        echo "$data_used" > "$TmpSim1DataFile"
		            flash_data_used=`cat "$Sim1DataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$Sim1DataFile"
				fi
				flash_data_used=`cat "$Sim1DataFile"`
		        flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		        new_flash_data=`expr $flash_data_used + $data_difference`
			    if [ $new_flash_data -ge $Sim1DataLimit ]
	            then
	                /etc/init.d/mwan3 stop
	                if [ ! -f "$Sim1DataFlagFile" ]
					then
					  touch "$Sim1DataFlagFile"
					  echo 1 > "$Sim1DataFlagFile"
					else
					   echo 1 > "$Sim1DataFlagFile"
					fi
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
				    [ ! -f /tmp/InterfaceStatus/CWAN1_0Status ] && touch /tmp/InterfaceStatus/CWAN1_0Status                                  
				     echo "`date` Interface CWAN1_0 DOWN" >> /tmp/InterfaceStatus/CWAN1_0Status  
				     echo "Sim Switch"
					if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
					then
						/usr/sbin/mwan3 restart > /dev/null 2>&1
						/bin/sleep 2
					elif [ "$mwan3status" = "none" ] 
					then
						mwan3 stop
					fi
				fi
		    else
				tx_data=$(cat /sys/class/net/3g-CWAN1_0/statistics/tx_bytes)     
				rx_data=$(cat /sys/class/net/3g-CWAN1_0/statistics/rx_bytes)     
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    tmp_data_used=`cat "$TmpSim1DataFile"`
			    data_difference=`expr $data_used - $tmp_data_used`  
			    if [ $data_difference -ge $Data_Storage_Threshold ]
			    then
			        echo "$data_used" > "$TmpSim1DataFile"
		            flash_data_used=`cat "$Sim1DataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$Sim1DataFile"
				fi
				flash_data_used=`cat "$Sim1DataFile"`
		        flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		        new_flash_data=`expr $flash_data_used + $data_difference`
			    if [ $new_flash_data -ge $Sim1DataLimit ]
	            then
	                /etc/init.d/mwan3 stop
	                if [ ! -f "$Sim1DataFlagFile" ]
					then
					  touch "$Sim1DataFlagFile"
					  echo 1 > "$Sim1DataFlagFile"
					else
					   echo 1 > "$Sim1DataFlagFile"
					fi
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
				    [ ! -f /tmp/InterfaceStatus/CWAN1_0Status ] && touch /tmp/InterfaceStatus/CWAN1_0Status                                  
				     echo "`date` Interface CWAN1_0 DOWN" >> /tmp/InterfaceStatus/CWAN1_0Status  
				     echo "Sim Switch"
					 if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
					then
						/usr/sbin/mwan3 restart > /dev/null 2>&1
						/bin/sleep 2
					elif [ "$mwan3status" = "none" ] 
					then
						mwan3 stop
					fi
				fi
			fi
		else
		    if [ ! -f "$TmpSim2DataFile" ]
		    then
		      touch "$TmpSim2DataFile"
		      echo 0 > "$TmpSim2DataFile"
		    fi
    	    if [ ! -f "$Sim2DataFile" ]
            then
                touch "$Sim2DataFile"
                echo "1,1,0" > "$Sim2DataFile"
            fi
			if [ "$Protocol" = "cdcether" ]                                
			then                                                           
				tx_data=$(cat /sys/class/net/usb0/statistics/tx_bytes)      
				rx_data=$(cat /sys/class/net/usb0/statistics/rx_bytes)      
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    tmp_data_used=`cat "$TmpSim2DataFile"`
			    data_difference=`expr $data_used - $tmp_data_used`  
			    if [ $data_difference -ge $Data_Storage_Threshold ]
			    then
			        echo "$data_used" > "$TmpSim2DataFile"
		            flash_data_used=`cat "$Sim2DataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$Sim2DataFile"
				fi
		        flash_data_used=`cat "$Sim2DataFile"`
		        flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		        new_flash_data=`expr $flash_data_used + $data_difference`
			    if [ $new_flash_data -ge $Sim2DataLimit ]
	            then
	                /etc/init.d/mwan3 stop
	                if [ ! -f "$Sim2DataFlagFile" ]
					then
					  touch "$Sim2DataFlagFile"
					  echo 1 > "$Sim2DataFlagFile"
					else
					   echo 1 > "$Sim2DataFlagFile"
					fi
	                /root/InterfaceManager/script/SimSwitch.sh CWAN1 1
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
				     echo "`date` Interface CWAN1_1 DOWN" >> /tmp/InterfaceStatus/CWAN1_1Status  
				     echo "Sim Switch"
					if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
					then
						/usr/sbin/mwan3 restart > /dev/null 2>&1
						/bin/sleep 2
					elif [ "$mwan3status" = "none" ] 
					then
					    mwan3 stop
					fi
				fi                                                        
			elif [ "$Protocol" = "qmi" ]                                   
			then                                                           
				tx_data=$(cat /sys/class/net/wwan0/statistics/tx_bytes)     
				rx_data=$(cat /sys/class/net/wwan0/statistics/rx_bytes)     
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    tmp_data_used=`cat "$TmpSim2DataFile"`
			    data_difference=`expr $data_used - $tmp_data_used`  
			    if [ $data_difference -ge $Data_Storage_Threshold ]
			    then
			        echo "$data_used" > "$TmpSim2DataFile"
		            flash_data_used=`cat "$Sim2DataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$Sim2DataFile"
				fi
				flash_data_used=`cat "$Sim2DataFile"`
		        flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		        new_flash_data=`expr $flash_data_used + $data_difference`
			    if [ $new_flash_data -ge $Sim2DataLimit ]
	            then
	                /etc/init.d/mwan3 stop
	                if [ ! -f "$Sim2DataFlagFile" ]
					then
					  touch "$Sim2DataFlagFile"
					  echo 1 > "$Sim2DataFlagFile"
					else
					   echo 1 > "$Sim2DataFlagFile"
					fi
	                /root/InterfaceManager/script/SimSwitch.sh CWAN1 1
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
				     echo "`date` Interface CWAN1_1 DOWN" >> /tmp/InterfaceStatus/CWAN1_1Status  
				     echo "Sim Switch"
					if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
					then
						/usr/sbin/mwan3 restart > /dev/null 2>&1
						/bin/sleep 2
					elif [ "$mwan3status" = "none" ] 
					then
					    mwan3 stop
					fi
				fi                                                                                                                 
			else                                                           
			    tx_data=$(cat /sys/class/net/3g-CWAN1_1/statistics/tx_bytes)
				rx_data=$(cat /sys/class/net/3g-CWAN1_1/statistics/rx_bytes)
			    sum=`expr $tx_data + $rx_data`
			    data_used=$(($sum / 1048576))
			    tmp_data_used=`cat "$TmpSim2DataFile"`
			    data_difference=`expr $data_used - $tmp_data_used`  
			    if [ $data_difference -ge $Data_Storage_Threshold ]
			    then
			        echo "$data_used" > "$TmpSim2DataFile"
		            flash_data_used=`cat "$Sim2DataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$Sim2DataFile"
				fi
				flash_data_used=`cat "$Sim2DataFile"`
		        flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		        new_flash_data=`expr $flash_data_used + $data_difference`
			    if [ $new_flash_data -ge $Sim2DataLimit ]
	            then
	                /etc/init.d/mwan3 stop
	                if [ ! -f "$Sim2DataFlagFile" ]
					then
					  touch "$Sim2DataFlagFile"
					  echo 1 > "$Sim2DataFlagFile"
					else
					   echo 1 > "$Sim2DataFlagFile"
					fi
	                /root/InterfaceManager/script/SimSwitch.sh CWAN1 1
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
				     echo "`date` Interface CWAN1_1 DOWN" >> /tmp/InterfaceStatus/CWAN1_1Status  
				     echo "Sim Switch"
					if [ "$mwan3status" = "failover" ] || [ "$mwan3status" = "balanced" ]
					then
						/usr/sbin/mwan3 restart > /dev/null 2>&1
						/bin/sleep 2
					elif [ "$mwan3status" = "none" ] 
					then
					    mwan3 stop
					fi
				fi 
			fi
		
		fi
else
	    if [ ! -f "$TmpSimDataFile" ]
	    then
	      touch "$TmpSimDataFile"
	      echo 0 > "$TmpSimDataFile"
	    fi
		if [ ! -f "$SimDataFile" ]
		then
			touch "$SimDataFile"
			echo "1,1,0" > "$SimDataFile"
		fi
		if [ "$Protocol" = "cdcether" ]                                
		then                                                           
			tx_data=$(cat /sys/class/net/usb0/statistics/tx_bytes)      
			rx_data=$(cat /sys/class/net/usb0/statistics/rx_bytes)      
		    sum=`expr $tx_data + $rx_data`
		    data_used=$(($sum / 1048576))
		    tmp_data_used=`cat "$TmpSimDataFile"`
		    data_difference=`expr $data_used - $tmp_data_used`  
		    if [ $data_difference -ge $Data_Storage_Threshold ]
		    then
		            echo "$data_used" > "$TmpSimDataFile"
		            flash_data_used=`cat "$SimDataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$SimDataFile"
			fi
            flash_data_used=`cat "$SimDataFile"`
            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
            new_flash_data=`expr $flash_data_used + $data_difference`
			if [ $new_flash_data -ge $Sim1DataLimit ]
            then
                echo "Sim Switch"
            fi     
		elif [ "$Protocol" = "qmi" ]                                   
		then                                                           
			tx_data=$(cat /sys/class/net/wwan0/statistics/tx_bytes)     
			rx_data=$(cat /sys/class/net/wwan0/statistics/rx_bytes)     
		    sum=`expr $tx_data + $rx_data`
		    data_used=$(($sum / 1048576))
		    tmp_data_used=`cat "$TmpSimDataFile"`
		    data_difference=`expr $data_used - $tmp_data_used`  
		    if [ $data_difference -ge $Data_Storage_Threshold ]
		    then
		            echo "$data_used" > "$TmpSimDataFile"
		            flash_data_used=`cat "$SimDataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$SimDataFile"
			fi  
			flash_data_used=`cat "$SimDataFile"`
            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
            new_flash_data=`expr $flash_data_used + $data_difference`
			if [ $new_flash_data -ge $Sim1DataLimit ]
            then
                echo "Sim Switch"
            fi   
		else                                                           
			tx_data=$(cat /sys/class/net/3g-CWAN1/statistics/tx_bytes)
			rx_data=$(cat /sys/class/net/3g-CWAN1/statistics/rx_bytes)
		    sum=`expr $tx_data + $rx_data`
		    data_used=$(($sum / 1048576))
		    tmp_data_used=`cat "$TmpSimDataFile"`
		    data_difference=`expr $data_used - $tmp_data_used`  
		    if [ $data_difference -ge $Data_Storage_Threshold ]
		    then
		            echo "$data_used" > "$TmpSimDataFile"
		            flash_data_used=`cat "$SimDataFile"`
		            num_writes=$(echo "$flash_data_used" | cut -d "," -f 1)
		            num_writes_full=$(echo "$flash_data_used" | cut -d "," -f 2)
		            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
		            new_flash_data=`expr $flash_data_used + $data_difference`
		            num_writes=`expr $num_writes + 1`
		            num_writes_full=`expr $num_writes_full + 1`
		            echo "${num_writes},${num_writes_full},${new_flash_data}" > "$SimDataFile"
			fi  
			flash_data_used=`cat "$SimDataFile"`
            flash_data_used=$(echo "$flash_data_used" | cut -d "," -f 3)
            new_flash_data=`expr $flash_data_used + $data_difference` 
			if [ $new_flash_data -ge $Sim1DataLimit ]
            then
                echo "Sim Switch"
            fi
	    fi
fi
fi
