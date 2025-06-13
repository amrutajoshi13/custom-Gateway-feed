#!/bin/sh

. /lib/functions.sh

rm /bin/updatevpnconfigoutput.txt
touch /bin/updatevpnconfigoutput.txt
chmod 0777 /bin/updatevpnconfigoutput.txt
ipsecstop="/etc/init.d/ipsec stop"
Updatedipsecstatus="/bin/ipsecstatus.sh"

ReadIpsecConfigFile()
{
	vpnread="$1" 

	config_get IpsecType "$vpnread" ipsectype
	config_get IpsecRole "$vpnread" ipsecrole
	config_get ConnectionEnable "$vpnread" connectionenable
	config_get ConnectionType "$vpnread" connectiontype
	config_get ConnectionMode "$vpnread" connectionmode
	config_get RemoteServerIP "$vpnread" remoteserverIP
 	config_get RemoteIP "$vpnread" remoteIP 
	config_get LocalId "$vpnread" localid
	#  config_get LocalSubnet "$vpnread" localsubnet
	config_get RemoteId "$vpnread" remoteid
	#  config_get RemoteSubnet "$vpnread" remotesubnet
	config_get KeyexChange "$vpnread" keyexchange
	config_get DpdDetectionEnable "$vpnread" dpddetectionenable
	config_get TimeInterval "$vpnread" timeinterval
	config_get TimeOut "$vpnread" timeout
	config_get Action "$vpnread" action
	config_get AuthenticationMethod "$vpnread" authenticationmethod
	config_get PskValue "$vpnread" pskvalue
	config_get P1Encrypalgorithm "$vpnread" p1encrypalgorithm
	config_get P1Authentication "$vpnread" p1authentication
	config_get P1DhGroup "$vpnread" p1dhgroup
	config_get P2Encrypalgorithm "$vpnread" p2encrypalgorithm
	config_get P2Authentication "$vpnread" p2authentication
	config_get P2Pfs "$vpnread" p2pfs
	config_get NoOfLocalSubnetToBypass "$vpnread" nooflocalsubnettobypass
	config_get LocalSubnetIp1 "$vpnread" localsubnetip1
	config_get LocalSubnetIp2 "$vpnread" localsubnetip2
	config_get LocalSubnetIp3 "$vpnread" localsubnetip3
	config_get LocalSubnetIp4 "$vpnread" localsubnetip4
	config_get LocalSubnetIp5 "$vpnread" localsubnetip5
	config_get NoOfLocalSubnets "$vpnread" nooflocalsubnets
	config_get LocalSubnet1 "$vpnread" localsubnet1
	config_get LocalSubnet2 "$vpnread" localsubnet2
	config_get NoOfRemoteSubnets "$vpnread" noofremotesubnets
	config_get RemoteSubnet1 "$vpnread" remotesubnet1
	config_get RemoteSubnet2 "$vpnread" remotesubnet2
	config_get RemoteSubnet3 "$vpnread" remotesubnet3
	config_get RemoteSubnet4 "$vpnread" remotesubnet4
	config_get RemoteSubnet5 "$vpnread" remotesubnet5
	config_get RemoteSubnet6 "$vpnread" remotesubnet6
	config_get RemoteSubnet7 "$vpnread" remotesubnet7
	config_get RemoteSubnet8 "$vpnread" remotesubnet8
	config_get aggressive    "$vpnread" aggressive
	config_get ikelifetime   "$vpnread" ikelifetime
	config_get lifetime      "$vpnread" lifetime
	config_get lanWifiConnectivity "$vpnread" lanWifiConnectivity
	config_get splitTunnel   "$vpnread" splitTunnel
}

UpdateIpsecConfig()
{
	vpn="$1"	
	echo "vpn is $vpn"
	ReadIpsecConfigFile "$vpn"

	if [ "$EnableIpsec" = "1" ]
	then
		if [ "$ConnectionEnable" = "1" ]
		then     
			uci set ipsec.general=ipsec
			uci set ipsec.general.uniqueids="on"
			
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
					interface_name="$match_ifname"
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
                                                                                                                    
    uci commit firewall
    sleep 1
    /etc/init.d/firewall reload
	   uci set ipsec."${vpn}"=remote
	   uci set ipsec."${vpn}".enabled="$ConnectionEnable"
            if [ $IpsecRole == "server" ]; then
               uci set ipsec."${vpn}".gateway="$RemoteIP"  
			else
   	        uci set ipsec."${vpn}".gateway="$RemoteServerIP"
            fi
	   #uci set ipsec."${vpn}".gateway="$RemoteServerIP"
           #uci set ipsec."${vpn}".gateway="$RemoteIP"
	   uci set ipsec."${vpn}".authentication_method="$AuthenticationMethod"
	   uci set ipsec."${vpn}".pre_shared_key="$PskValue"
	   uci set ipsec."${vpn}".exchange_mode="default"
	   uci set ipsec."${vpn}".local_identifier="$LocalId"
	   uci set ipsec."${vpn}".remote_identifier="$RemoteId"
	   uci set ipsec."${vpn}".aggressive="$aggressive"
	   uci set ipsec."${vpn}".ikelifetime="$ikelifetime"
	   uci set ipsec."${vpn}".lifetime="$lifetime"
	   
	   uci set ipsec."${vpn}_proposel_one"=p1_proposal
	   uci set ipsec."${vpn}_proposel_one".encryption_algorithm_p1="$P1Encrypalgorithm"
	   uci set ipsec."${vpn}_proposel_one".hash_algorithm="$P1Authentication"
	   uci set ipsec."${vpn}_proposel_one".dh_group="$P1DhGroup"
	   
	   uci set ipsec."${vpn}_proposel_two"=p2_proposal
	   uci set ipsec."${vpn}_proposel_two".encryption_algorithm_p2="$P2Encrypalgorithm"
	   uci set ipsec."${vpn}_proposel_two".authentication_algorithm="$P2Authentication"
	   uci set ipsec."${vpn}_proposel_two".pfs_group="$P2Pfs"
	   
	   lanip=$(uci get network.SW_LAN.ipaddr | cut -d "." -f 1,2,3)
	   wifiip=$(uci get network.ra0.ipaddr | cut -d "." -f 1,2,3)
	   #ip rule del to $lanip.0/24 lookup main priority 100
	   #ip rule del to $wifiip.0/24 lookup main priority 101
	   if [ "$splitTunnel" = "0" ]
	   then
	   		uci set ipsec."${vpn}".lanWifiConnectivity="$lanWifiConnectivity"
	   		uci set ipsec."${vpn}".NoOfLocalSubnetToBypass="$NoOfLocalSubnetToBypass"
		   if [ "$lanWifiConnectivity" = "1" ]
		   then 
				if [ "$NoOfLocalSubnetToBypass" = "1" ] 
				then
					uci set ipsec."${vpn}".passthrough_ip1="$LocalSubnetIp1"
				elif  [ "$NoOfLocalSubnetToBypass" = "2" ] 
				then
					uci set ipsec."${vpn}".passthrough_ip1="$LocalSubnetIp1"
					uci set ipsec."${vpn}".passthrough_ip2="$LocalSubnetIp2"
				elif  [ "$NoOfLocalSubnetToBypass" = "3" ] 
				then
					uci set ipsec."${vpn}".passthrough_ip1="$LocalSubnetIp1"
					uci set ipsec."${vpn}".passthrough_ip2="$LocalSubnetIp2"
					uci set ipsec."${vpn}".passthrough_ip3="$LocalSubnetIp3"
				elif  [ "$NoOfLocalSubnetToBypass" = "4" ] 
				then
					uci set ipsec."${vpn}".passthrough_ip1="$LocalSubnetIp1"
					uci set ipsec."${vpn}".passthrough_ip2="$LocalSubnetIp2"
					uci set ipsec."${vpn}".passthrough_ip3="$LocalSubnetIp3"
					uci set ipsec."${vpn}".passthrough_ip4="$LocalSubnetIp4"
				elif  [ "$NoOfLocalSubnetToBypass" = "5" ] 
				then
					uci set ipsec."${vpn}".passthrough_ip1="$LocalSubnetIp1"
					uci set ipsec."${vpn}".passthrough_ip2="$LocalSubnetIp2"
					uci set ipsec."${vpn}".passthrough_ip3="$LocalSubnetIp3"
					uci set ipsec."${vpn}".passthrough_ip4="$LocalSubnetIp4"
					uci set ipsec."${vpn}".passthrough_ip5="$LocalSubnetIp5"
				fi
		   fi
		  
		   uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".remote_subnet="0.0.0.0/0"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel"
	       
	       if [ "$NoOfLocalSubnets" = "2" ]
	       then
				uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
				uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
				uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="0.0.0.0/0"
				uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
				uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
				uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
				if [ "$DpdDetectionEnable" = "1" ]
				then
					uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
					uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
				fi
				uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       fi
	       
	   else
	   if [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "1" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel"
	    elif [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "2" ]
	    then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	   	elif [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "3" ]
	    then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"

	   	elif [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "4" ]
	    then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"

	   	elif [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "5" ]
	    then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"          

	   	elif [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "6" ]
	    then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"

	   	elif [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "7" ]
	    then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"     
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".remote_subnet="${RemoteSubnet7}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"

	   	elif [ "$NoOfLocalSubnets" = "1" ] && [ "$NoOfRemoteSubnets" = "8" ]
	    then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="$TimeInterval" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"     
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".remote_subnet="${RemoteSubnet7}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"
           uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".remote_subnet="${RemoteSubnet8}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"
	       	       
	   elif [ "$NoOfLocalSubnets" = "2" ] && [ "$NoOfRemoteSubnets" = "1" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	   elif [ "$NoOfLocalSubnets" = "2" ] && [ "$NoOfRemoteSubnets" = "2" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
     
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"

	   elif [ "$NoOfLocalSubnets" = "2" ] && [ "$NoOfRemoteSubnets" = "3" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
     
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"	       

	   elif [ "$NoOfLocalSubnets" = "2" ] && [ "$NoOfRemoteSubnets" = "4" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
     
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8" 


	   elif [ "$NoOfLocalSubnets" = "2" ] && [ "$NoOfRemoteSubnets" = "5" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
     
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"


	   elif [ "$NoOfLocalSubnets" = "2" ] && [ "$NoOfRemoteSubnets" = "6" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       	if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"
     
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12"


	   elif [ "$NoOfLocalSubnets" = "2" ] && [ "$NoOfRemoteSubnets" = "7" ]
	   then
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".remote_subnet="${RemoteSubnet7}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"
     
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13"	       
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".remote_subnet="${RemoteSubnet7}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".ddaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14"
	   else
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel1"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel2"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel3"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel4"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel5"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel6"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".remote_subnet="${RemoteSubnet7}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel7"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".local_subnet="${LocalSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".remote_subnet="${RemoteSubnet8}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel8"
     
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".remote_subnet="${RemoteSubnet1}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel9"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".remote_subnet="${RemoteSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel10"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".remote_subnet="${RemoteSubnet3}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel11"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".remote_subnet="${RemoteSubnet4}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel12"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".remote_subnet="${RemoteSubnet5}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel13"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".remote_subnet="${RemoteSubnet6}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel14"	       
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15".remote_subnet="${RemoteSubnet7}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel15"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16"=tunnel
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16".local_subnet="${LocalSubnet2}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16".remote_subnet="${RemoteSubnet8}"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16".p2_proposal="${vpn}_proposel_two"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16".keyexchange="$KeyexChange"
	       uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16".mode="$ConnectionMode"
	       if [ "$DpdDetectionEnable" = "1" ]
	       then
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16".dpdaction="$Action" 
	         uci set ipsec."${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16".dpddelay="${TimeInterval}s" 
	       fi
	       uci add_list ipsec."${vpn}".tunnel="${vpn}_${NoOfLocalSubnets}_${NoOfRemoteSubnets}_tunnel16"	       
	   fi
	   fi
	 else
		uci delete ipsec."${vpn}" 
		uci delete ipsec.general.interface
		uci delete firewall.ipsec_rule1.src                                                                                     
		uci delete firewall.ipsec_rule2.src                                                                                     
		uci delete firewall.ipsec_rule3.src
	 fi
    else
           response=$($ipsecstop)
           response=$($Updatedipsecstatus)
   fi
   uci commit ipsec
}


vpnconfigfile="/etc/config/vpnconfig1"
ipsecconfigfile="/etc/config/ipsec"

rm -rf "$ipsecconfigfile"
touch "$ipsecconfigfile"

EnableIpsec=$(uci get vpnconfig1.general.enableipsecgeneral)

config_load "$vpnconfigfile" 
config_foreach UpdateIpsecConfig vpnconfig1


/etc/init.d/ipsec stop
sleep 5
/etc/init.d/ipsec start

sleep 5

if [ "$EnableIpsec" = "1" ]
then
    sed -i '/ipsecstatus.sh/d' /etc/crontabs/root                                                                                  
    echo "*/1 * * * * /bin/ipsecstatus.sh" >> /etc/crontabs/root   
    
    sed -i '/IpsecRestart.sh/d' /etc/crontabs/root                                                                                  
    echo "*/15 * * * * /root/InterfaceManager/script/IpsecRestart.sh" >> /etc/crontabs/root                                                                                                                                                                                             
	/etc/init.d/cron restart 
	/usr/sbin/ipsec restart
else

sed -i '/ipsecstatus.sh/d' /etc/crontabs/root

sed -i '/IpsecRestart.sh/d' /etc/crontabs/root
/usr/sbin/ipsec stop
/etc/init.d/ipsec stop
fi

