#!/bin/sh

. /lib/functions.sh

ReadConfig()
{
 config_load "$ConfigFile"
 #~ config_get CellularDataSwitchOnSpeedEnable sysconfig cellulardataswitchonspeedenable
 config_get EnableCellular sysconfig enablecellular
 #~ config_get SpeedTestServerUrl sysconfig speedtestserverurl
 #~ config_get SpeedTestInterval sysconfig speedtestinterval
 #~ config_get DownloadSpeedThreshold sysconfig downloadspeedthreshold
 #~ config_get UploadSpeedThreshold sysconfig uploadspeedthreshold
  config_get Cellular_Mode sysconfig CellularOperationMode
  config_get PrimarySimSwitchBackEnable sysconfig primarysimswitchbackenable
  config_get PrimarySimSwitchBackTime sysconfig primarysimswitchbacktime
}

simswitchconfigUCIPath="/etc/config/simswitchconfig"
simswitchconfigsection="simswitchconfig"

config_load "$simswitchconfigUCIPath"
config_get CellularDataSwitchOnSpeedEnable "$simswitchconfigsection" cellulardataswitchonspeedenable 
config_get SpeedTestServerUrl "$simswitchconfigsection" speedtestserverurl
config_get SpeedTestInterval "$simswitchconfigsection" speedtestinterval
config_get DownloadSpeedThreshold "$simswitchconfigsection" downloadspeedthreshold
config_get UploadSpeedThreshold "$simswitchconfigsection" uploadspeedthreshold

/bin/cellulardatausagemanagerscript.sh

NMS_Enable=$(uci get remoteconfig.nms.nmsenable)

ConfigFile="/etc/config/sysconfig"

Sim1DataFlagFile="/etc/sim1dataflag"
Sim2DataFlagFile="/etc/sim2dataflag"

ReadConfig

if [ "$EnableCellular" = "1" ]
then
	if [ "$CellularDataSwitchOnSpeedEnable" = "1" ]
	then
		SpeedTestOutput=$(speedtest-netperf.sh -H "$SpeedTestServerUrl" -t "$SpeedTestInterval" -n 2)
		DownloadMbps=$(echo "$SpeedTestOutput" | grep -i Mbps | grep -i "Download" | cut -d ":" -f 2 | sed s/Mbps// | tr -d '\011\012\013\014\015\040') 
		if [ ! -z $DownloadMbps ]
		then
		  DownloadKbps=$(echo "scale=2;$DownloadMbps * 1000.000" | bc)
		  DownloadKbps=$(echo $DownloadKbps | cut -d "." -f 1)
		fi
		UploadMbps=$(echo "$SpeedTestOutput" | grep -i Mbps | grep -i "Upload" | cut -d ":" -f 2 | sed s/Mbps// | tr -d '\011\012\013\014\015\040')  
		if [ ! -z $UploadMbps ] 
		then                                                                                                                                          
		  UploadKbps=$(echo "scale=2;$UploadMbps * 1000.000" | bc)
		  UploadKbps=$(echo $UploadKbps | cut -d "." -f 1) 
		fi                                                                                                                                           
		if [ $DownloadKbps -le $DownloadSpeedThreshold ] || [ $UploadKbps -le $UploadSpeedThreshold ]
		then
			if [ "${Cellular_Mode}" = "singlecellulardualsim" ]
			then
				sim=$(cat /tmp/simnumfile)
				if [ "$sim" = "1" ]
				then
	                /etc/init.d/mwan3 stop
					if [ ! -f "$Sim2DataFlagFile" ]
					then
						touch "$Sim2DataFlagFile"
						echo 0 > "$Sim2DataFlagFile"
					fi
					Sim2DataFlag=`cat "$Sim2DataFlagFile"`
					if [ "$Sim2DataFlag" = "0" ]
					then
					    /root/InterfaceManager/script/SimSwitch.sh CWAN1 2
					    sleep 10
					  	SpeedTestOutput=$(speedtest-netperf.sh -H "$SpeedTestServerUrl" -t "$SpeedTestInterval" -n 2)
						DownloadMbps=$(echo "$SpeedTestOutput" | grep -i Mbps | grep -i "Download" | cut -d ":" -f 2 | sed s/Mbps// | tr -d '\011\012\013\014\015\040') 
						if [ ! -z $DownloadMbps ]
						then
						    DownloadKbps=$(echo "scale=2;$DownloadMbps * 1000.000" | bc)
						    DownloadKbps=$(echo $DownloadKbps | cut -d "." -f 1)
						fi
						UploadMbps=$(echo "$SpeedTestOutput" | grep -i Mbps | grep -i "Upload" | cut -d ":" -f 2 | sed s/Mbps// | tr -d '\011\012\013\014\015\040')  
						if [ ! -z $UploadMbps ] 
						then                                                                                                                                          
						   UploadKbps=$(echo "scale=2;$UploadMbps * 1000.000" | bc)
						   UploadKbps=$(echo $UploadKbps | cut -d "." -f 1) 
						fi                                                                                                                                            
						if [ $DownloadKbps -le $DownloadSpeedThreshold ] || [ $UploadKbps -le $UploadSpeedThreshold ]
						then   
						    if [ ! -f "$Sim1DataFlagFile" ]
						    then
						        touch "$Sim1DataFlagFile"
						        echo 0 > "$Sim1DataFlagFile"
						    fi
						    Sim1DataFlag=`cat "$Sim1DataFlagFile"`
							if [ "$Sim1DataFlag" = "0" ]
							then  
							   /root/InterfaceManager/script/SimSwitch.sh CWAN1 1
							fi
						else
						   	if [ ! -f "$Sim1DataFlagFile" ]
						    then
						        touch "$Sim1DataFlagFile"
						        echo 0 > "$Sim1DataFlagFile"
						    fi
						    Sim1DataFlag=`cat "$Sim1DataFlagFile"`
							if [ "$Sim1DataFlag" = "0" ]
							then  
							    if [ "$PrimarySimSwitchBackEnable" = "1" ]
								then
									pid=$(pgrep -f "/root/InterfaceManager/script/PrimarySwitch.sh")
									kill -TERM "$pid" > /dev/null 2>&1
									sleep 1
									kill -KILL "$pid" > /dev/null 2>&1
									/root/InterfaceManager/script/PrimarySwitch.sh "$PrimarySimSwitchBackTime" CWAN1 1 &         
								fi
							fi
						fi
					else
		   			    if [ "$PrimarySimSwitchBackEnable" = "1" ]
					    then
						    pid=$(pgrep -f "/root/InterfaceManager/script/PrimarySwitch.sh")
						    kill -TERM "$pid" > /dev/null 2>&1
						    sleep 1
					 	    kill -KILL "$pid" > /dev/null 2>&1
					    fi
					    /root/InterfaceManager/script/SimSwitch.sh CWAN1 1
					fi
	                sleep 4
				    [ ! -f /tmp/InterfaceStatus/CWAN1_0Status ] && touch /tmp/InterfaceStatus/CWAN1_0Status                                  
				    echo "`date` Interface CWAN1_0 DOWN" >> /tmp/InterfaceStatus/CWAN1_0Status  
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
					/usr/sbin/mwan3 restart
				fi
			fi
		fi 
	fi
fi

exit 0

