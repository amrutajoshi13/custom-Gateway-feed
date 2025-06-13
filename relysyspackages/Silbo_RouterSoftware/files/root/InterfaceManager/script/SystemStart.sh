#!/bin/sh

. /lib/functions.sh


cellularwan1interface="CWAN1"
cellularwan2interface="CWAN2"
cellularwan3interface="CWAN3"
cellularwan1sim1interface="CWAN1_0"
cellularwan1sim2interface="CWAN1_1"
wifiap="ra0"
wifiap1="ra1"
wifista="WIFI_WAN"
#wifista1="WIFI_WAN"

#IPV6 Variables 
cellularwan6sim1interface="wan6c1"
cellularwan6sim2interface="wan6c2"

#InternetOverLAN="1" 
InternetOverWifi="1"

Select=$(uci get mwan3config.general.select)

#emptying the file /etc/dnsmasq.conf
echo -n > /etc/dnsmasq.conf 

UpdateRelayServer()
{
	sh /root/InterfaceManager/script/DHCP_Relay.sh
}

UpdateNetworkConfig()
{
	#Go to Network_interface for ethernet configurations.
	/root/InterfaceManager/script/Network_Interface.sh
	
}


ReadSystemConfigFile()
{
		config_load "$SystemConfigFile"

        #CellularConfig
		#config_get CellularOperationModelocal sysconfig CellularOperationMode
		#config_get CellularModem1 sysconfig cellularmodem1
		
		################# not really required ####################
		
		#config_get Protocol1EC20 sysconfig protocol1EC20
		#config_get Manufacturerlocal1 sysconfig Manufacturer1
		#config_get Model1 sysconfig model1
		#config_get PortType1 sysconfig porttype1
		#config_get VendorId1 sysconfig vendorid1
		#config_get ProductId1 sysconfig productid1
		#config_get DataPort1 sysconfig dataport1
		#config_get ComPort1 sysconfig comport1
		#config_get SmsPort1 sysconfig smsport1
		
		#config_get Manufacturerlocal2 sysconfig Manufacturer2
		#config_get Model2 sysconfig model2
		#config_get PortType2 sysconfig porttype2
		#config_get VendorId2 sysconfig vendorid2
		#config_get ProductId2 sysconfig productid2
		#config_get DataPort2 sysconfig dataport2
		#config_get ComPort2 sysconfig comport2
		#config_get SmsPort2 sysconfig smsport2
		
		################# not really required ####################
		
		#config_get MonitorEnable1 sysconfig monitorenable1
		#config_get QueryModematAnalytics1 sysconfig querymodematanalytics1
		#config_get DataTestEnable1 sysconfig datatestenable1
		#config_get PingTestEnable1 sysconfig pingtestenable1
		#config_get PingIp1 sysconfig pingip1
		#config_get MonitorEnable2 sysconfig monitorenable2
		#config_get QueryModematAnalytics2 sysconfig querymodematanalytics2
		#config_get DataTestEnable2 sysconfig datatestenable2
		#config_get PingTestEnable2 sysconfig pingtestenable2
		#config_get PingIp2 sysconfig pingip2
		#config_get DataEnable1 sysconfig dataenable
		#config_get Cellular1 sysconfig cellular
		#config_get Service1 sysconfig service
		#config_get Apn1 sysconfig apn
		#config_get Pdp1 sysconfig pdp
		#config_get PinCode1 sysconfig pincode
		#config_get UserName1 sysconfig username
		#config_get Password1 sysconfig password
		#config_get Auth1 sysconfig auth
		#config_get DataEnable2 sysconfig dataenable2
		#config_get Cellular2 sysconfig cellular2
		#config_get Sim2Service sysconfig sim2service
		#config_get Sim2Apn sysconfig sim2apn
		#config_get Sim2Pdp sysconfig sim2pdp
		#config_get Sim2PinCode sysconfig sim2pincode
		#config_get Sim2UserName sysconfig sim2username
		#config_get Sim2Password sysconfig sim2password
		#config_get Sim2Auth sysconfig sim2auth
		#config_get EnableCellular sysconfig enablecellular
		#config_get UsbBusPath1 sysconfig usbbuspath1
		#config_get UsbBusPath2 sysconfig usbbuspath2
		#config_get ActionInterval1 sysconfig actioninterval1
		#config_get ActionInterval2 sysconfig actioninterval2
		#config_get Protocol1 sysconfig protocol1
		#config_get Protocol2 sysconfig protocol2
		#config_get mtu sysconfig mtu
	   
		#config_get SimSwitch sysconfig simswitch
		#config_get PDP1 sysconfig pdp
		#config_get PDP2 sysconfig sim2pdp
		
		#CellularConfig
		config_get CellularOperationModelocal sysconfig CellularOperationMode
		config_get CellularModem1 sysconfig cellularmodem1
		config_get Protocol1EC20 sysconfig protocol1EC20
		config_get Manufacturerlocal1 sysconfig Manufacturer1
		config_get Model1 sysconfig model1
		config_get PortType1 sysconfig porttype1
		config_get VendorId1 sysconfig vendorid1
		config_get ProductId1 sysconfig productid1
		config_get DataPort1 sysconfig dataport1
		config_get ComPort1 sysconfig comport1
		config_get SmsPort1 sysconfig smsport1
		config_get Manufacturerlocal2 sysconfig Manufacturer2
		config_get Model2 sysconfig model2
		config_get PortType2 sysconfig porttype2
		config_get VendorId2 sysconfig vendorid2
		config_get ProductId2 sysconfig productid2
		config_get DataPort2 sysconfig dataport2
		config_get ComPort2 sysconfig comport2
		config_get SmsPort2 sysconfig smsport2
		config_get DeviceId2 sysconfig deviceid2
		config_get ApiKey2 sysconfig apikey2
		config_get MonitorEnable1 sysconfig monitorenable1
		config_get QueryModematAnalytics1 sysconfig querymodematanalytics1
		config_get DataTestEnable1 sysconfig datatestenable1
		config_get PingTestEnable1 sysconfig pingtestenable1
		config_get PingIp1 sysconfig pingip1
		config_get MonitorEnable2 sysconfig monitorenable2
		config_get QueryModematAnalytics2 sysconfig querymodematanalytics2
		config_get DataTestEnable2 sysconfig datatestenable2
		config_get PingTestEnable2 sysconfig pingtestenable2
		config_get PingIp2 sysconfig pingip2
		config_get DataEnable1 sysconfig dataenable
		config_get Cellular1 sysconfig cellular
		config_get Service1 sysconfig service
		config_get Apn1 sysconfig apn
		config_get Pdp1 sysconfig pdp
		config_get PinCode1 sysconfig pincode
		config_get UserName1 sysconfig username
		config_get Password1 sysconfig password
		config_get Auth1 sysconfig auth
		config_get DataEnable2 sysconfig dataenable2
		config_get Cellular2 sysconfig cellular2
		config_get Sim2Service sysconfig sim2service
		config_get Sim2Apn sysconfig sim2apn
		config_get Sim2Pdp sysconfig sim2pdp
		config_get Sim2PinCode sysconfig sim2pincode
		config_get Sim2UserName sysconfig sim2username
		config_get Sim2Password sysconfig sim2password
		config_get Sim2Auth sysconfig sim2auth
		config_get EnableCellular sysconfig enablecellular
		config_get UsbBusPath1 sysconfig usbbuspath1
		config_get UsbBusPath2 sysconfig usbbuspath2
		config_get ActionInterval1 sysconfig actioninterval1
		config_get ActionInterval2 sysconfig actioninterval2
		config_get Protocol1 sysconfig protocol1
		config_get Protocol2 sysconfig protocol2
		config_get SimSwitch sysconfig simswitch
		config_get PDP1 sysconfig pdp
		config_get PDP2 sysconfig sim2pdp
		config_get mtu sysconfig mtu
		
	    #BandlockConfig
	    config_get bandselectenable bandlock bandselectenable
	    config_get enableoperator bandlock enableoperator
	    config_get operatorlockenable bandlock operatorlockenable
	    config_get Code bandlock Code
		
        #WifiConfig	
		config_get WifiDevice wificonfig wifidevice
		config_get Radio0AccessPointEnable wificonfig wifi1enable
		config_get TxPower wificonfig TxPower
		config_get WifiDevicesChannel wificonfig wifideviceschannel
		config_get CountryCode wificonfig CountryCode
		config_get Wifi1Enable wificonfig wifi1enable
		config_get Radio0StationEnable wificonfig radio0stationenable
		config_get Wifi1Ssid wificonfig wifi1ssid
		config_get Wifi1Key wificonfig wifi1key
		config_get Wifi1Mode wificonfig wifi1mode
		config_get Wifi1StaMode wificonfig wifi1stamode
		config_get wifi1authentication wificonfig wifi1authentication
		config_get wifi1encryption wificonfig wifi1encryption
		config_get Wifi1StaSsid wificonfig wifi1stassid
		config_get Wifi1StaEncryption wificonfig wifi1staencryption
		config_get Wifi1StaKey wificonfig wifi1stakey
		config_get Wifi2Enable wificonfig wifi2enable
		config_get Wifi2Ssid wificonfig wifi2ssid
		config_get Wifi2Key wificonfig wifi2key
		config_get Wifi2Mode wificonfig wifi2mode
		config_get InternetOverWifi wificonfig internetoverwifi
		config_get LanWifiBridgeEnable wificonfig lanwifibridgeenable
		config_get Radio0DhcpIp wificonfig radio0dhcpip
		config_get Radio0DHCPRange wificonfig Radio0DHCPrange
		config_get Radio0DHCPLimit wificonfig Radio0DHCPlimit
		config_get ScheduledOnOff wificonfig ScheduledOnOff
		config_get WmmEnable wificonfig WmmEnable
		config_get WpsEnable wificonfig WpsEnable
		config_get EnableDhcpRelay wificonfig EnableDhcpRelay
		config_get WifiRelayServerIP wificonfig WifiRelayServerIP
		config_get WifiRelayLocalIP wificonfig WifiRelayLocalIP
		
		#GuestWifiConfig
		config_get guestwifissid guestwifi guestwifissid
		config_get guestwifiencryption guestwifi guestwifiencryption
		config_get guestwifikey guestwifi guestwifikey
		config_get guestwifi1authentication guestwifi guestwifi1authentication
		config_get guestwifi1encryption guestwifi guestwifi1encryption
		config_get guestradio0dhcpip guestwifi guestradio0dhcpip
		config_get guestRadio0DHCPrange guestwifi guestRadio0DHCPrange
		config_get guestRadio0DHCPlimit guestwifi guestRadio0DHCPlimit
		config_get guestwifienable guestwifi guestwifienable
		config_get guestwifi1authentication guestwifi guestwifi1authentication
		config_get guestwifi1encryption guestwifi guestwifi1encryption
	
		
		#SMSConfigsysconfig 
		config_get SmsEnable1 smsconfig smsenable1
		config_get SmsCenterNumber1 smsconfig smscenternumber1
		config_get ApiKey1 smsconfig smsapikey
		config_get SmsCenterNumber2 smsconfig smscenternumber2
		config_get ApiKey2 smsconfig apikey2
		config_get DeviceId1 smsconfig smsdeviceid
		config_get SmsEnable2 smsconfig smsenable2
		config_get DeviceId2 smsconfig deviceid2
		config_get SmsResponseServerEnable1 smsconfig smsresponseserverenable
		
		config_get SmsServerNumber1 smsconfig smsservernumber1
		config_get SmsServerNumber2 smsconfig smsservernumber2
		config_get SmsServerNumber3 smsconfig smsservernumber3
		config_get SmsServerNumber4 smsconfig smsservernumber4
		config_get SmsServerNumber5 smsconfig smsservernumber5

        #WirelessConfig
		config_get ScheduledOnOff wirelessconfig ScheduledOnOff
		config_get DayOfWeek wirelessconfig DayOfWeek
		config_get from wirelessconfig from
		config_get fromHours wirelessconfig fromHours
		config_get fromMinutes wirelessconfig fromMinutes
		config_get to wirelessconfig to
		config_get toHours wirelessconfig toHours
		config_get toMinutes wirelessconfig toMinutes

}


ReadMwanConfigFile_Failover()
{ 
	#uci delete mwan3.failover.use_member
	#uci commit mwan3
	Select=$(uci get mwan3config.general.select)
	if [ "$Select" =  "failover" ]
    then  
    #sh /root/InterfaceManager/script/Mwan3_Failover.sh
	config_load "$FailoverConfigFile"
	config_foreach UpdateMwanConfig_Failover mwan3config
	fi
	
		
}

ReadMwanConfigFile_LoadBalancing()
{ 
	#uci delete mwan3.balanced.use_member
	#uci commit mwan3
	Select=$(uci get mwan3config.general.select)
	if [ "$Select" =  "balanced" ]
    then  
    #sh /root/InterfaceManager/script/Mwan3_LoadBalancing.sh
	config_load "$LoadBalancingConfigFile"
	config_foreach UpdateMwanConfig_LoadBalancing loadbalancingconfig
	fi
	
		
}

UpdateMwanConfig_Failover()
{
	echo "..."
	
	if [ "$Select" =  "failover" ]
    then
	      
	      #Default Rule V4
      uci set mwan3.default_rule_v4=rule
      uci set mwan3.default_rule_v4.dest_ip='0.0.0.0/0'
      uci set mwan3.default_rule_v4.family='ipv4'
      uci set mwan3.default_rule_v4.use_policy='failover'

	  #Default Rule V6
      uci set mwan3.default_rule_v6=rule
      uci set mwan3.default_rule_v6.dest_ip='::/0'
      uci set mwan3.default_rule_v6.family='ipv6'
      uci set mwan3.default_rule_v6.use_policy='failover'     
 
	  #policy for both V4 and V6
      uci set mwan3.failover=policy
      uci set mwan3.failover.last_resort='default'
	      
	
		config_get NameCwan1 "$cellularwan1interface" name
		config_get Cwan1Priority "$cellularwan1interface" wanpriority
		config_get Cwan1Enabled "$cellularwan1interface" enabled
        config_get Cwan1trackmethod "$cellularwan1interface" track_method
		config_get Cwan1TrackIp1 "$cellularwan1interface" trackIp1
		config_get Cwan1TrackIp2 "$cellularwan1interface" trackIp2
		config_get Cwan1TrackIp3 "$cellularwan1interface" trackIp3
		config_get Cwan1TrackIp4 "$cellularwan1interface" trackIp4
		config_get Cwan1Reliability "$cellularwan1interface" reliability
		config_get Cwan1Count "$cellularwan1interface" count
		config_get Cwan1Up "$cellularwan1interface" up
		config_get Cwan1Down "$cellularwan1interface" down
		config_get Cwan1validtrackip "$cellularwan1interface" validtrackip
		config_get Cwan1flush_conntrack "$cellularwan1interface" flush_conntrack
		config_get Cwan1advance_settings "$cellularwan1interface" advance_settings
		config_get Cwan1timeout "$cellularwan1interface" timeout
		config_get Cwan1interval "$cellularwan1interface" interval
		config_get Cwan1check_quality "$cellularwan1interface" check_quality
		config_get Cwan1failure_latency "$cellularwan1interface" failure_latency
	    config_get Cwan1recovery_latency "$cellularwan1interface" recovery_latency
		config_get Cwan1failure_loss "$cellularwan1interface" failure_loss
		config_get Cwan1recovery_loss "$cellularwan1interface" recovery_loss
   
		config_get NameCwan2 "$cellularwan2interface" name
		config_get Cwan2Priority "$cellularwan2interface" wanpriority
        config_get Cwan2Enabled "$cellularwan2interface" enabled
	    config_get Cwan2trackmethod "$cellularwan2interface" track_method
	    config_get Cwan2TrackIp1 "$cellularwan2interface" trackIp1
		config_get Cwan2TrackIp2 "$cellularwan2interface" trackIp2
		config_get Cwan2TrackIp3 "$cellularwan2interface" trackIp3
		config_get Cwan2TrackIp4 "$cellularwan2interface" trackIp4
		config_get Cwan2flush_conntrack "$cellularwan2interface" flush_conntrack
		config_get Cwan2advance_settings "$cellularwan2interface" advance_settings
		config_get Cwan2timeout "$cellularwan2interface" timeout
		config_get Cwan2interval "$cellularwan2interface" interval
		config_get Cwan2check_quality "$cellularwan2interface" check_quality
		config_get Cwan2failure_latency "$cellularwan2interface" failure_latency
	    config_get Cwan2recovery_latency "$cellularwan2interface" recovery_latency
		config_get Cwan2failure_loss "$cellularwan2interface" failure_loss
		config_get Cwan2recovery_loss "$cellularwan2interface" recovery_loss
   
		config_get NameCwansim1 "$cellularwan1sim1interface" name
		config_get Cwan1sim1Priority "$cellularwan1sim1interface" wanpriority
		config_get Cwan1sim1Enabled "$cellularwan1sim1interface" enabled
        config_get Cwan1sim1trackmethod "$cellularwan1sim1interface" track_method
		config_get Cwan1sim1TrackIp1 "$cellularwan1sim1interface" trackIp1
		config_get Cwan1sim1TrackIp2 "$cellularwan1sim1interface" trackIp2
		config_get Cwan1sim1TrackIp3 "$cellularwan1sim1interface" trackIp3
		config_get Cwan1sim1TrackIp4 "$cellularwan1sim1interface" trackIp4
		config_get Cwan1sim1Reliability "$cellularwan1sim1interface" reliability
		config_get Cwan1sim1Count "$cellularwan1sim1interface" count
		config_get Cwan1sim1Up "$cellularwan1sim1interface" up
		config_get Cwan1sim1Down "$cellularwan1sim1interface" down
		config_get Cwan1sim1validtrackip "$cellularwan1sim1interface" validtrackip
		config_get Cwan1sim1flush_conntrack "$cellularwan1sim1interface" flush_conntrack
		config_get Cwan1sim1advance_settings "$cellularwan1sim1interface" advance_settings
		config_get Cwan1sim1timeout "$cellularwan1sim1interface" timeout
		config_get Cwan1sim1interval "$cellularwan1sim1interface" interval
		config_get Cwan1sim1check_quality "$cellularwan1sim1interface" check_quality
		config_get Cwan1sim1failure_latency "$cellularwan1sim1interface" failure_latency
	    config_get Cwan1sim1recovery_latency "$cellularwan1sim1interface" recovery_latency
		config_get Cwan1sim1failure_loss "$cellularwan1sim1interface" failure_loss
		config_get Cwan1sim1recovery_loss "$cellularwan1sim1interface" recovery_loss
		
   
		config_get NameCwansim2 "$cellularwan1sim2interface" name
		config_get Cwan1sim2Priority "$cellularwan1sim2interface" wanpriority
		config_get Cwan1sim2Enabled "$cellularwan1sim2interface" enabled
        config_get Cwan1sim2trackmethod "$cellularwan1sim2interface" track_method
		config_get Cwan1sim2TrackIp1 "$cellularwan1sim2interface" trackIp1
		config_get Cwan1sim2TrackIp2 "$cellularwan1sim2interface" trackIp2
		config_get Cwan1sim2TrackIp3 "$cellularwan1sim2interface" trackIp3
		config_get Cwan1sim2TrackIp4 "$cellularwan1sim2interface" trackIp4
		config_get Cwan1sim2Reliability "$cellularwan1sim2interface" reliability
		config_get Cwan1sim2Count "$cellularwan1sim2interface" count
		config_get Cwan1sim2Up "$cellularwan1sim2interface" up
		config_get Cwan1sim2Down "$cellularwan1sim2interface" down
		config_get Cwan1sim2validtrackip "$cellularwan1sim2interface" validtrackip
		config_get Cwan1sim2flush_conntrack "$cellularwan1sim2interface" flush_conntrack
		config_get Cwan1sim2advance_settings "$cellularwan1sim2interface" advance_settings
		config_get Cwan1sim2timeout "$cellularwan1sim2interface" timeout
		config_get Cwan1sim2interval "$cellularwan1sim2interface" interval
		config_get Cwan1sim2check_quality "$cellularwan1sim2interface" check_quality
		config_get Cwan1sim2failure_latency "$cellularwan1sim2interface" failure_latency
	    config_get Cwan1sim2recovery_latency "$cellularwan1sim2interface" recovery_latency
		config_get Cwan1sim2failure_loss "$cellularwan1sim2interface" failure_loss
		config_get Cwan1sim2recovery_loss "$cellularwan1sim2interface" recovery_loss
	
		#IPV6 variables
		config_get NameCwan6sim1 "$cellularwan6sim1interface" name
		config_get Cwan6sim1Priority "$cellularwan6sim1interface" wanpriority
		config_get Cwan6sim1Enabled "$cellularwan6sim1interface" enabled
        config_get Cwan6sim1trackmethod "$cellularwan6sim1interface" track_method
		config_get Cwan6sim1TrackIp1 "$cellularwan6sim1interface" trackIp1
		config_get Cwan6sim1TrackIp2 "$cellularwan6sim1interface" trackIp2
		config_get Cwan6sim1TrackIp3 "$cellularwan6sim1interface" trackIp3
		config_get Cwan6sim1TrackIp4 "$cellularwan6sim1interface" trackIp4
		config_get Cwan6sim1Reliability "$cellularwan6sim1interface" reliability
		config_get Cwan6sim1Count "$cellularwan6sim1interface" count
		config_get Cwan6sim1Up "$cellularwan6sim1interface" up
		config_get Cwan6sim1Down "$cellularwan6sim1interface" down
		config_get Cwan6sim1validtrackip "$cellularwan6sim1interface" validtrackip
		config_get Cwan6sim1flush_conntrack "$cellularwan6sim1interface" flush_conntrack
		config_get Cwan6sim1advance_settings "$cellularwan6sim1interface" advance_settings
		config_get Cwan6sim1timeout "$cellularwan6sim1interface" timeout
		config_get Cwan6sim1interval "$cellularwan6sim1interface" interval
		config_get Cwan6sim1check_quality "$cellularwan6sim1interface" check_quality
		config_get Cwan6sim1failure_latency "$cellularwan6sim1interface" failure_latency
	    config_get Cwan6sim1recovery_latency "$cellularwan6sim1interface" recovery_latency
		config_get Cwan6sim1failure_loss "$cellularwan6sim1interface" failure_loss
		config_get Cwan6sim1recovery_loss "$cellularwan6sim1interface" recovery_loss
   
		config_get NameCwan6sim2 "$cellularwan6sim2interface" name
		config_get Cwan6sim2Priority "$cellularwan6sim2interface" wanpriority
		config_get Cwan6sim2Enabled "$cellularwan6sim2interface" enabled
        config_get Cwan6sim2trackmethod "$cellularwan6sim2interface" track_method
		config_get Cwan6sim2TrackIp1 "$cellularwan6sim2interface" trackIp1
		config_get Cwan6sim2TrackIp2 "$cellularwan6sim2interface" trackIp2
		config_get Cwan6sim2TrackIp3 "$cellularwan6sim2interface" trackIp3
		config_get Cwan6sim2TrackIp4 "$cellularwan6sim2interface" trackIp4
		config_get Cwan6sim2Reliability "$cellularwan6sim2interface" reliability
		config_get Cwan6sim2Count "$cellularwan6sim2interface" count
		config_get Cwan6sim2Up "$cellularwan6sim2interface" up
		config_get Cwan6sim2Down "$cellularwan6sim2interface" down
		config_get Cwan6sim2validtrackip "$cellularwan6sim2interface" validtrackip
		config_get Cwan6sim2flush_conntrack "$cellularwan6sim2interface" flush_conntrack
		config_get Cwan6sim2advance_settings "$cellularwan6sim2interface" advance_settings
		config_get Cwan6sim2timeout "$cellularwan6sim2interface" timeout
		config_get Cwan6sim2interval "$cellularwan6sim2interface" interval
		config_get Cwan6sim2check_quality "$cellularwan6sim2interface" check_quality
		config_get Cwan6sim2failure_latency "$cellularwan6sim2interface" failure_latency
	    config_get Cwan6sim2recovery_latency "$cellularwan6sim2interface" recovery_latency
		config_get Cwan6sim2failure_loss "$cellularwan6sim2interface" failure_loss
		config_get Cwan6sim2recovery_loss "$cellularwan6sim2interface" recovery_loss
	  
		config_get NameWifiWan "$wifista" name
		config_get WifiWanPriority "$wifista" wanpriority
		config_get WifiWanEnabled "$wifista" enabled
        config_get WifiWantrackmethod "$wifista" track_method
		config_get WifiWanTrackIp1 "$wifista" trackIp1
		config_get WifiWanTrackIp2 "$wifista" trackIp2
		config_get WifiWanTrackIp3 "$wifista" trackIp3
		config_get WifiWanTrackIp4 "$wifista" trackIp4
		config_get WifiWanReliability "$wifista" reliability
		config_get WifiWanCount "$wifista" count
		config_get WifiWanUp "$wifista" up
		config_get WifiWanDown "$wifista" down
		config_get WifiWanvalidtrackip "$wifista" validtrackip
		config_get WifiWanflush_conntrack "$wifista" flush_conntrack
		config_get WifiWanadvance_settings "$wifista" advance_settings
		config_get WifiWantimeout "$wifista" timeout
		config_get WifiWaninterval "$wifista" interval
		config_get WifiWancheck_quality "$wifista" check_quality
		config_get WifiWanfailure_latency "$wifista" failure_latency
	    config_get WifiWanrecovery_latency "$wifista" recovery_latency
		config_get WifiWanfailure_loss "$wifista" failure_loss
		config_get WifiWanrecovery_loss "$wifista" recovery_loss
		config_get WifiWaninitial_state "$wifista" initial_state
	
	    #uci delete mwan3."${cellularwan1interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan2interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan3interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan1sim1interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan1sim2interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan6sim1interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan6sim2interface}" > /dev/null 2>&1
	    
	    uci delete mwan3.CWAN1 > /dev/null 2>&1         
		uci delete mwan3.CWAN2 > /dev/null 2>&1              
		uci delete mwan3.CWAN1_0  > /dev/null 2>&1               
		uci delete mwan3.CWAN1_1 > /dev/null 2>&1              
		uci delete mwan3.WIFI_WAN > /dev/null 2>&1              
		uci delete mwan3.wan6c1 > /dev/null 2>&1               
		uci delete mwan3.wan6c2 > /dev/null 2>&1              
	    uci delete mwan3.WIFI_WAN_only > /dev/null 2>&1
	    
	    uci delete mwan3.WIFI_WAN_failover > /dev/null 2>&1
		uci delete mwan3.CWAN1_failover > /dev/null 2>&1
		uci delete mwan3.CWAN2_failover > /dev/null 2>&1
		uci delete mwan3.CWAN1_0_failover > /dev/null 2>&1
		uci delete mwan3.CWAN1_1_failover > /dev/null 2>&1
		uci delete mwan3.wan6c1_failover > /dev/null 2>&1
		uci delete mwan3.wan6c2_failover > /dev/null 2>&1
			
	if [ "$Wifi1Enable" = "1" ]
	then 
		#apsta
		if [ "$Wifi1Mode" = "sta" ] ||  [ "$Wifi1Mode" = "apsta" ] 
		then 
			     uci delete mwan3."$wifista" > /dev/null 2>&1
			     delete_trackip=$(uci get mwan3."$wifista".track_ip)
                 uci del_list mwan3."$wifista".track_ip="$delete_trackip" 
			     
			     uci del_list mwan3.failover.use_member="${wifista}_failover"
			     
			         #member
					 uci set mwan3.${wifista}_failover=member
					 uci set mwan3.${wifista}_failover.interface="$wifista"
					 uci set mwan3.${wifista}_failover.metric="$WifiWanPriority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${wifista}_failover"
	            
					 uci set mwan3."$wifista"=interface
					 uci set mwan3."$wifista".enabled="$WifiWanEnabled"
                     uci set mwan3."$wifista".track_method="$WifiWantrackmethod"
                                             
                     if [ "$WifiWanvalidtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
					 fi
					 if [ "$WifiWanvalidtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
		             uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp2"
					 fi
					 if [ "$WifiWanvalidtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp2"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp3"
					 fi
					 if [ "$WifiWanvalidtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp2"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp3"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp4"
					 fi
	                 uci set mwan3."$wifista".family="ipv4"
	                 uci set mwan3."$wifista".reliability="$WifiWanReliability"
	                 uci set mwan3."$wifista".count="$WifiWanCount"
	                 uci set mwan3."$wifista".down="$WifiWanDown"
	                 uci set mwan3."$wifista".up="$WifiWanUp"
	              
	                 if [ "$WifiWanflush_conntrack" = "1" ]
					then
						uci add_list mwan3."${wifista}".flush_conntrack="ifup"
						uci add_list mwan3."${wifista}".flush_conntrack="ifdown"
						uci add_list mwan3."${wifista}".flush_conntrack="connected"
						uci add_list mwan3."${wifista}".flush_conntrack="disconnected"
					else
					    uci del_list mwan3."${wifista}".flush_conntrack
					    uci del_list mwan3."${wifista}".flush_conntrack="ifdown"
						uci del_list mwan3."${wifista}".flush_conntrack="connected"
						uci del_list mwan3."${wifista}".flush_conntrack="disconnected"	
					fi
					
					if [ "$WifiWaninitial_state" = "1" ]
					then
						uci set mwan3."${wifista}".initial_state="offline"
					fi
					
					if [ "$WifiWanadvance_settings" =  "1" ]
					then 
						uci set mwan3."${wifista}".timeout="$WifiWantimeout"
						uci set mwan3."${wifista}".interval="$WifiWaninterval"
						uci set mwan3."${wifista}".check_quality="$WifiWancheck_quality"
						if [ "$WifiWancheck_quality" =  "1" ]
						then 
							uci set mwan3."${wifista}".failure_latency="$WifiWanfailure_latency"
							uci set mwan3."${wifista}".recovery_latency="$WifiWanrecovery_latency"
							uci set mwan3."${wifista}".failure_loss="$WifiWanfailure_loss"
							uci set mwan3."${wifista}".recovery_loss="$WifiWanrecovery_loss"
						else
							uci delete mwan3."${wifista}".failure_latency
							uci delete mwan3."${wifista}".recovery_latency
							uci delete mwan3."${wifista}".failure_loss
							uci delete mwan3."${wifista}".recovery_loss	
						fi
					else
						uci delete mwan3."${wifista}".timeout
						uci delete mwan3."${wifista}".interval
						uci delete mwan3."${wifista}".check_quality
						uci delete mwan3."${wifista}".failure_latency
						uci delete mwan3."${wifista}".recovery_latency
						uci delete mwan3."${wifista}".failure_loss
						uci delete mwan3."${wifista}".recovery_loss	
					fi
	        
	    else
			uci delete mwan3.WIFI_WAN_failover > /dev/null 2>&1
			uci delete mwan3.WIFI_WAN
		fi
	 fi
	
	if [ "$EnableCellular" = "1" ]
	then
	      echo "$EnableCellular"
			if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
			then
			
				uci delete mwan3.CWAN1_1_failover > /dev/null 2>&1
				uci delete mwan3.CWAN1_0_failover > /dev/null 2>&1
				uci delete mwan3.wan6c1_failover > /dev/null 2>&1
				uci delete mwan3.wan6c2_failover > /dev/null 2>&1   
				
				
				uci delete mwan3.CWAN1_0 > /dev/null 2>&1   
				uci delete mwan3.CWAN1_1 > /dev/null 2>&1   
				uci delete mwan3.wan6c1 > /dev/null 2>&1   
				uci delete mwan3.wan6c2 > /dev/null 2>&1   
				
					uci delete mwan3.CWAN1_failover > /dev/null 2>&1
					uci delete mwan3."$cellularwan1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1interface".track_ip)
					uci del_list mwan3."$cellularwan1interface".track_ip="$delete_trackip" 
			     
			        uci del_list mwan3.failover.use_member="${cellularwan1interface}_failover"
			     
			         #member
					 uci set mwan3.${cellularwan1interface}_failover=member
					 uci set mwan3.${cellularwan1interface}_failover.interface="$cellularwan1interface"
					 uci set mwan3.${cellularwan1interface}_failover.metric="$Cwan1Priority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan1interface}_failover"
	            
					 uci set mwan3."$cellularwan1interface"=interface
					 uci set mwan3."$cellularwan1interface".enabled="$Cwan1Enabled"
                     uci set mwan3."$cellularwan1interface".track_method="$Cwan1trackmethod"
                
                     if [ "$Cwan1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
					 fi
					 if [ "$Cwan1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
					 fi
					 if [ "$Cwan1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
					 fi
					 if [ "$Cwan1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1interface".family="ipv4"
	                 uci set mwan3."$cellularwan1interface".reliability="$Cwan1Reliability"
	                 uci set mwan3."$cellularwan1interface".count="$Cwan1Count"
	                 uci set mwan3."$cellularwan1interface".down="$Cwan1Down"
	                 uci set mwan3."$cellularwan1interface".up="$Cwan1Up"
	                 
	                  if [ "$Cwan1flush_conntrack" =  "1" ]
	                 then 
						uci add_list mwan3."${cellularwan1interface}".flush_conntrack="ifup"
						uci add_list mwan3."${cellularwan1interface}".flush_conntrack="ifdown"
						uci add_list mwan3."${cellularwan1interface}".flush_conntrack="connected"
						uci add_list mwan3."${cellularwan1interface}".flush_conntrack="disconnected"
					else
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="ifup"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="ifdown"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="connected"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="disconnected"
					 fi
					 
					if [ "$Cwan1advance_settings" =  "1" ]
					then 
						uci set mwan3."${cellularwan1interface}".timeout="$Cwan1timeout"
						uci set mwan3."${cellularwan1interface}".interval="$Cwan1interval"
						uci set mwan3."${cellularwan1interface}".check_quality="$Cwan1check_quality"
						if [ "$Cwan1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan1interface}".failure_latency="$Cwan1failure_latency"
							uci set mwan3."${cellularwan1interface}".recovery_latency="$Cwan1recovery_latency"
							uci set mwan3."${cellularwan1interface}".failure_loss="$Cwan1failure_loss"
							uci set mwan3."${cellularwan1interface}".recovery_loss="$Cwan1recovery_loss"
						else
							uci delete mwan3."${cellularwan1interface}".failure_latency
							uci delete mwan3."${cellularwan1interface}".recovery_latency
							uci delete mwan3."${cellularwan1interface}".failure_loss
							uci delete mwan3."${cellularwan1interface}".recovery_loss	
						fi	
					else
						uci delete mwan3."${cellularwan1interface}".timeout
						uci delete mwan3."${cellularwan1interface}".interval
						uci delete mwan3."${cellularwan1interface}".check_quality
						uci delete mwan3."${cellularwan1interface}".failure_latency
						uci delete mwan3."${cellularwan1interface}".recovery_latency
						uci delete mwan3."${cellularwan1interface}".failure_loss
						uci delete mwan3."${cellularwan1interface}".recovery_loss	
					fi
	
				
					uci delete mwan3."$cellularwan2interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan2interface".track_ip)
					uci del_list mwan3."$cellularwan2interface".track_ip="$delete_trackip" 
			     
			        uci del_list mwan3.failover.use_member="${cellularwan2interface}_failover"
			        
			         #member
					 uci set mwan3.${cellularwan2interface}_failover=member
					 uci set mwan3.${cellularwan2interface}_failover.interface="$cellularwan2interface"
					 uci set mwan3.${cellularwan2interface}_failover.metric="$Cwan2Priority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan2interface}_failover"
	            
					 uci set mwan3."$cellularwan2interface"=interface
					 uci set mwan3."$cellularwan2interface".enabled="$Cwan2Enabled"
                     uci set mwan3."$cellularwan2interface".track_method="$Cwan2trackmethod"
                
                     if [ "$Cwan2validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
					 fi
					 if [ "$Cwan2validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
		             uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp2"
					 fi
					 if [ "$Cwan2validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp2"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp3"
					 fi
					 if [ "$Cwan2validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp2"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp3"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan2interface".family="ipv4"
	                 uci set mwan3."$cellularwan2interface".reliability="$Cwan2Reliability"
	                 uci set mwan3."$cellularwan2interface".count="$Cwan2Count"
	                 uci set mwan3."$cellularwan2interface".down="$Cwan2Down"
	                 uci set mwan3."$cellularwan2interface".up="$Cwan2Up"
	            
	                 if [ "$Cwan2flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan2advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan2interface}".timeout="$Cwan2timeout"
						uci set mwan3."${cellularwan2interface}".interval="$Cwan2interval"
						uci set mwan3."${cellularwan2interface}".check_quality="$Cwan2check_quality"
						if [ "$Cwan2check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan2interface}".failure_latency="$Cwan2failure_latency"
							uci set mwan3."${cellularwan2interface}".recovery_latency="$Cwan2recovery_latency"
							uci set mwan3."${cellularwan2interface}".failure_loss="$Cwan2failure_loss"
							uci set mwan3."${cellularwan2interface}".recovery_loss="$Cwan2recovery_loss"
						else
							uci delete mwan3."${cellularwan2interface}".failure_latency
							uci delete mwan3."${cellularwan2interface}".recovery_latency
							uci delete mwan3."${cellularwan2interface}".failure_loss
							uci delete mwan3."${cellularwan2interface}".recovery_loss	
						fi	
					 else
						uci delete mwan3."${cellularwan2interface}".timeout
						uci delete mwan3."${cellularwan2interface}".interval
						uci delete mwan3."${cellularwan2interface}".check_quality
						uci delete mwan3."${cellularwan2interface}".failure_latency
						uci delete mwan3."${cellularwan2interface}".recovery_latency
						uci delete mwan3."${cellularwan2interface}".failure_loss
						uci delete mwan3."${cellularwan2interface}".recovery_loss	
					 fi
	        
				
			elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
			then                    
				uci delete mwan3.CWAN1_failover > /dev/null 2>&1
				uci delete mwan3.CWAN2_failover > /dev/null 2>&1
				uci delete mwan3.wan6c1_failover > /dev/null 2>&1
				uci delete mwan3.wan6c2_failover > /dev/null 2>&1 
				
				uci delete mwan3.wan6c1 > /dev/null 2>&1
				uci delete mwan3.wan6c2 > /dev/null 2>&1
				uci delete mwan3.CWAN1 > /dev/null 2>&1
				uci delete mwan3.CWAN2 > /dev/null 2>&1
				
				#IPV4 sim1 valid trackip
				if [ "$PDP1" = "IPV4" ]  || [ "$PDP1" = "IPV4V6" ]
				then 
				
			        uci delete mwan3.${cellularwan1sim1interface}_failover > /dev/null 2>&1
				    uci delete mwan3."$cellularwan1sim1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1sim1interface".track_ip)
					uci del_list mwan3."$cellularwan1sim1interface".track_ip="$delete_trackip" 
			     
			        uci del_list mwan3.failover.use_member="${cellularwan1sim1interface}_failover"
			      
			         #member
					 uci set mwan3.${cellularwan1sim1interface}_failover=member
					 uci set mwan3.${cellularwan1sim1interface}_failover.interface="$cellularwan1sim1interface"
					 uci set mwan3.${cellularwan1sim1interface}_failover.metric="$Cwan1sim1Priority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan1sim1interface}_failover"
	            
					 uci set mwan3."$cellularwan1sim1interface"=interface
					 uci set mwan3."$cellularwan1sim1interface".enabled="$Cwan1sim1Enabled"
                     uci set mwan3."$cellularwan1sim1interface".track_method="$Cwan1sim1trackmethod"
                
                     if [ "$Cwan1sim1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
					 fi
					 if [ "$Cwan1sim1validtrackip" =  "2" ]
					 then 
		                 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
		                 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp2"
					 fi
					 if [ "$Cwan1sim1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp2"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp3"
					 fi
					 if [ "$Cwan1sim1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp2"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp3"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1sim1interface".family="ipv4"
	                 uci set mwan3."$cellularwan1sim1interface".reliability="$Cwan1sim1Reliability"
	                 uci set mwan3."$cellularwan1sim1interface".count="$Cwan1sim1Count"
	                 uci set mwan3."$cellularwan1sim1interface".timeout="2"
	                 uci set mwan3."$cellularwan1sim1interface".down="$Cwan1sim1Down"
	                 uci set mwan3."$cellularwan1sim1interface".up="$Cwan1sim1Up"
	              
	                  if [ "$Cwan1sim1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan1sim1advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan1sim1interface}".timeout="$Cwan1sim1timeout"
						uci set mwan3."${cellularwan1sim1interface}".interval="$Cwan1sim1interval"
						uci set mwan3."${cellularwan1sim1interface}".check_quality="$Cwan1sim1check_quality"
						if [ "$Cwan1sim1check_quality" =  "1" ]
						then 
							uci set mwan3."${cellularwan1sim1interface}".failure_latency="$Cwan1sim1failure_latency"
							uci set mwan3."${cellularwan1sim1interface}".recovery_latency="$Cwan1sim1recovery_latency"
							uci set mwan3."${cellularwan1sim1interface}".failure_loss="$Cwan1sim1failure_loss"
							uci set mwan3."${cellularwan1sim1interface}".recovery_loss="$Cwan1sim1recovery_loss"
						else
							uci delete mwan3."${cellularwan1sim1interface}".failure_latency
							uci delete mwan3."${cellularwan1sim1interface}".recovery_latency
							uci delete mwan3."${cellularwan1sim1interface}".failure_loss
							uci delete mwan3."${cellularwan1sim1interface}".recovery_loss	
						fi
					 else
						uci delete mwan3."${cellularwan1sim1interface}".timeout
						uci delete mwan3."${cellularwan1sim1interface}".interval
						uci delete mwan3."${cellularwan1sim1interface}".check_quality
						uci delete mwan3."${cellularwan1sim1interface}".failure_latency
						uci delete mwan3."${cellularwan1sim1interface}".recovery_latency
						uci delete mwan3."${cellularwan1sim1interface}".failure_loss
						uci delete mwan3."${cellularwan1sim1interface}".recovery_loss	
					 fi
	               	                 
				fi
				
				#IPV4 sim2 valid trackip
				
				if [ "$PDP2" = "IPV4" ]  || [ "$PDP2" = "IPV4V6" ]
				then 
					uci delete mwan3.${cellularwan1sim2interface}_failover > /dev/null 2>&1
				    uci delete mwan3."$cellularwan1sim2interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1sim2interface".track_ip)
					uci del_list mwan3."$cellularwan1sim2interface".track_ip="$delete_trackip" 
			        
			        uci del_list mwan3.failover.use_member="${cellularwan1sim2interface}_failover"
			        
			         #member
					 uci set mwan3.${cellularwan1sim2interface}_failover=member
					 uci set mwan3.${cellularwan1sim2interface}_failover.interface="$cellularwan1sim2interface"
					 uci set mwan3.${cellularwan1sim2interface}_failover.metric="$Cwan1sim2Priority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan1sim2interface}_failover"
	            
					 uci set mwan3."$cellularwan1sim2interface"=interface
					 uci set mwan3."$cellularwan1sim2interface".enabled="$Cwan1sim2Enabled"
                     uci set mwan3."$cellularwan1sim2interface".track_method="$Cwan1sim2trackmethod"
                
                     if [ "$Cwan1sim2validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
					 fi
					 if [ "$Cwan1sim2validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
		             uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp2"
					 fi
					 if [ "$Cwan1sim2validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp2"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp3"
					 fi
					 if [ "$Cwan1sim2validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp2"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp3"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1sim2interface".family="ipv4"
	                 uci set mwan3."$cellularwan1sim2interface".reliability="$Cwan1sim2Reliability"
	                 uci set mwan3."$cellularwan1sim2interface".count="$Cwan1sim2Count"
	                 uci set mwan3."$cellularwan1sim2interface".timeout="2"
	                 uci set mwan3."$cellularwan1sim2interface".down="$Cwan1sim2Down"
	                 uci set mwan3."$cellularwan1sim2interface".up="$Cwan1sim2Up"
	                 
	                 if [ "$Cwan1sim2flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="disconnected"	
					else
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="disconnected"	
					 fi
					 
					 if [ "$Cwan1sim2advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan1sim2interface}".timeout="$Cwan1sim2timeout"
						uci set mwan3."${cellularwan1sim2interface}".interval="$Cwan1sim2interval"
						uci set mwan3."${cellularwan1sim2interface}".check_quality="$Cwan1sim2check_quality"
						if [ "$Cwan1sim2check_quality" =  "1" ]
						then 
							uci set mwan3."${cellularwan1sim2interface}".failure_latency="$Cwan1sim2failure_latency"
							uci set mwan3."${cellularwan1sim2interface}".recovery_latency="$Cwan1sim2recovery_latency"
							uci set mwan3."${cellularwan1sim2interface}".failure_loss="$Cwan1sim2failure_loss"
							uci set mwan3."${cellularwan1sim2interface}".recovery_loss="$Cwan1sim2recovery_loss"
						else
							uci delete mwan3."${cellularwan1sim2interface}".failure_latency
							uci delete mwan3."${cellularwan1sim2interface}".recovery_latency
							uci delete mwan3."${cellularwan1sim2interface}".failure_loss
							uci delete mwan3."${cellularwan1sim2interface}".recovery_loss
						fi
					 else
						uci delete mwan3."${cellularwan1sim2interface}".timeout
						uci delete mwan3."${cellularwan1sim2interface}".interval
						uci delete mwan3."${cellularwan1sim2interface}".check_quality
						uci delete mwan3."${cellularwan1sim2interface}".failure_latency
						uci delete mwan3."${cellularwan1sim2interface}".recovery_latency
						uci delete mwan3."${cellularwan1sim2interface}".failure_loss
						uci delete mwan3."${cellularwan1sim2interface}".recovery_loss	
					 fi
	                 
				fi
			
			
			#IPV6 update for sim1 and sim2
			
			if [ "$PDP1" = "IPV6" ] 
			then 
			        uci delete mwan3.${cellularwan6sim1interface}_failover > /dev/null 2>&1
			        uci delete mwan3."$cellularwan6sim1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan6sim1interface".track_ip)
					uci del_list mwan3."$cellularwan6sim1interface".track_ip="$delete_trackip" 
			     
			        uci del_list mwan3.failover.use_member="${cellularwan6sim1interface}_failover"
			     
			         #member
					 uci set mwan3.${cellularwan6sim1interface}_failover=member
					 uci set mwan3.${cellularwan6sim1interface}_failover.interface="$cellularwan6sim1interface"
					 uci set mwan3.${cellularwan6sim1interface}_failover.metric="$Cwan6sim1Priority"
                     uci set mwan3."$cellularwan6sim1interface".track_method="$Cwan6sim1trackmethod"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan6sim1interface}_failover"
	            
					 uci set mwan3."$cellularwan6sim1interface"=interface
					 uci set mwan3."$cellularwan6sim1interface".enabled="$Cwan6sim1Enabled"
                
                     if [ "$Cwan6sim1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan6sim1interface".family="ipv4"
	                 uci set mwan3."$cellularwan6sim1interface".reliability="$Cwan6sim1Reliability"
	                 uci set mwan3."$cellularwan6sim1interface".count="$Cwan6sim1Count"
	                 uci set mwan3."$cellularwan6sim1interface".timeout="2"
	                 uci set mwan3."$cellularwan6sim1interface".down="$Cwan6sim1Down"
	                 uci set mwan3."$cellularwan6sim1interface".up="$Cwan6sim1Up"
	                 
	                 if [ "$Cwan6sim1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan6sim1advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan6sim1interface}".timeout="$Cwan6sim1timeout"
						uci set mwan3."${cellularwan6sim1interface}".interval="$Cwan6sim1interval"
						uci set mwan3."${cellularwan6sim1interface}".check_quality="$Cwan6sim1check_quality"
						if [ "$Cwan6sim1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan6sim1interface}".failure_latency="$Cwan6sim1failure_latency"
							uci set mwan3."${cellularwan6sim1interface}".recovery_latency="$Cwan6sim1recovery_latency"
							uci set mwan3."${cellularwan6sim1interface}".failure_loss="$Cwan6sim1failure_loss"
							uci set mwan3."${cellularwan6sim1interface}".recovery_loss="$Cwan6sim1recovery_loss"
						else
							uci delete mwan3."${cellularwan6sim1interface}".failure_latency
							uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
							uci delete mwan3."${cellularwan6sim1interface}".failure_loss
							uci delete mwan3."${cellularwan6sim1interface}".recovery_loss
						fi
					 else
						uci delete mwan3."${cellularwan6sim1interface}".timeout
						uci delete mwan3."${cellularwan6sim1interface}".interval
						uci delete mwan3."${cellularwan6sim1interface}".check_quality
						uci delete mwan3."${cellularwan6sim1interface}".failure_latency
						uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
						uci delete mwan3."${cellularwan6sim1interface}".failure_loss
						uci delete mwan3."${cellularwan6sim1interface}".recovery_loss	
					 fi
			   fi
			
		       if [ "$PDP2" = "IPV6" ]
			   then  
					uci delete mwan3.${cellularwan6sim2interface}_failover > /dev/null 2>&1
			        uci delete mwan3."$cellularwan6sim2interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan6sim2interface".track_ip)
					uci del_list mwan3."$cellularwan6sim2interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.failover.use_member="${cellularwan6sim2interface}_failover"
			     
			         #member
					 uci set mwan3.${cellularwan6sim2interface}_failover=member
					 uci set mwan3.${cellularwan6sim2interface}_failover.interface="$cellularwan6sim2interface"
					 uci set mwan3.${cellularwan6sim2interface}_failover.metric="$Cwan6sim2Priority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan6sim2interface}_failover"
	            
					 uci set mwan3."$cellularwan6sim2interface"=interface
					 uci set mwan3."$cellularwan6sim2interface".enabled="$Cwan6sim2Enabled"
                     uci set mwan3."$cellularwan6sim2interface".track_method="$Cwan6sim2trackmethod"
                
                     if [ "$Cwan6sim2validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
					 fi
					 if [ "$Cwan6sim2validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
		             uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp2"
					 fi
					 if [ "$Cwan6sim2validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp2"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp3"
					 fi
					 if [ "$Cwan6sim2validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp2"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp3"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan6sim2interface".family="ipv4"
	                 uci set mwan3."$cellularwan6sim2interface".reliability="$Cwan6sim2Reliability"
	                 uci set mwan3."$cellularwan6sim2interface".count="$Cwan6sim2Count"
	                 uci set mwan3."$cellularwan6sim2interface".timeout="2"
	                 uci set mwan3."$cellularwan6sim2interface".down="$Cwan6sim2Down"
	                 uci set mwan3."$cellularwan6sim2interface".up="$Cwan6sim2Up"
	                 
	                 if [ "$Cwan6sim2flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan6sim2advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan6sim2interface}".timeout="$Cwan6sim2timeout"
						uci set mwan3."${cellularwan6sim2interface}".interval="$Cwan6sim2interval"
						uci set mwan3."${cellularwan6sim2interface}".check_quality="$Cwan6sim2check_quality"
						if [ "$Cwan6sim2check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan6sim2interface}".failure_latency="$Cwan6sim2failure_latency"
							uci set mwan3."${cellularwan6sim2interface}".recovery_latency="$Cwan6sim2recovery_latency"
							uci set mwan3."${cellularwan6sim2interface}".failure_loss="$Cwan6sim2failure_loss"
							uci set mwan3."${cellularwan6sim2interface}".recovery_loss="$Cwan6sim2recovery_loss"
						else
							uci delete mwan3."${cellularwan6sim2interface}".failure_latency
							uci delete mwan3."${cellularwan6sim2interface}".recovery_latency
							uci delete mwan3."${cellularwan6sim2interface}".failure_loss
							uci delete mwan3."${cellularwan6sim2interface}".recovery_loss	
						fi
					 else
						uci delete mwan3."${cellularwan6sim2interface}".timeout
						uci delete mwan3."${cellularwan6sim2interface}".interval
						uci delete mwan3."${cellularwan6sim2interface}".check_quality
						uci delete mwan3."${cellularwan6sim2interface}".failure_latency
						uci delete mwan3."${cellularwan6sim2interface}".recovery_latency
						uci delete mwan3."${cellularwan6sim2interface}".failure_loss
						uci delete mwan3."${cellularwan6sim2interface}".recovery_loss	
					 fi
			   fi
					
		 else
			 uci delete mwan3.CWAN1_0_failover > /dev/null 2>&1
			 uci delete mwan3.CWAN1_1_failover > /dev/null 2>&1  
			 uci delete mwan3.wan6c2_failover > /dev/null 2>&1    
			 uci delete mwan3.wan6c1_failover > /dev/null 2>&1     
			 uci delete mwan3.CWAN1_failover > /dev/null 2>&1
			 uci delete mwan3.CWAN1_failover > /dev/null 2>&1
			 
			 uci delete mwan3.CWAN1_0 > /dev/null 2>&1
			 uci delete mwan3.CWAN1_1 > /dev/null 2>&1
			 uci delete mwan3.CWAN1 > /dev/null 2>&1
			 uci delete mwan3.CWAN2 > /dev/null 2>&1
			 uci delete mwan3.wan6c1 > /dev/null 2>&1
			 uci delete mwan3.wan6c2 > /dev/null 2>&1
			
		   #IPV4 update			 
	       if [ "$PDP1" = "IPV4" ]  || [ "$PDP1" = "IPV4V6" ]
	       then 
	            echo "$PDP1" >> /tmp/trackmethod.txt
					uci delete mwan3.${cellularwan1interface}_failover > /dev/null 2>&1
					uci delete mwan3."$cellularwan1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1interface".track_ip)
					uci del_list mwan3."$cellularwan1interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.failover.use_member="${cellularwan1interface}_failover"
			     
			         #member
					 uci set mwan3.${cellularwan1interface}_failover=member
					 uci set mwan3.${cellularwan1interface}_failover.interface="$cellularwan1interface"
					 uci set mwan3.${cellularwan1interface}_failover.metric="$Cwan1Priority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan1interface}_failover"
	            
					 uci set mwan3."$cellularwan1interface"=interface
					 uci set mwan3."$cellularwan1interface".enabled="$Cwan1Enabled"
                     uci set mwan3."$cellularwan1interface".track_method="$Cwan1trackmethod"
                
                     if [ "$Cwan1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
					 fi
					 if [ "$Cwan1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
					 fi
					 if [ "$Cwan1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
					 fi
					 if [ "$Cwan1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1interface".family="ipv4"
	                 uci set mwan3."$cellularwan1interface".reliability="$Cwan1Reliability"
	                 uci set mwan3."$cellularwan1interface".count="$Cwan1Count"
	                 uci set mwan3."$cellularwan1interface".timeout="2"
	                 uci set mwan3."$cellularwan1interface".down="$Cwan1Down"
	                 uci set mwan3."$cellularwan1interface".up="$Cwan1Up"
	                  
	                 if [ "$Cwan1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan1interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan1interface}".flush_conntrack="disconnected"
					else
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="ifup"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="ifdown"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="connected"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="disconnected"
					 fi
	                 
	                 if [ "$Cwan1advance_settings" =  "1" ]
					then 
						uci set mwan3."${cellularwan1interface}".timeout="$Cwan1timeout"
						uci set mwan3."${cellularwan1interface}".interval="$Cwan1interval"
						uci set mwan3."${cellularwan1interface}".check_quality="$Cwan1check_quality"
						if [ "$Cwan1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan1interface}".failure_latency="$Cwan1failure_latency"
							uci set mwan3."${cellularwan1interface}".recovery_latency="$Cwan1recovery_latency"
							uci set mwan3."${cellularwan1interface}".failure_loss="$Cwan1failure_loss"
							uci set mwan3."${cellularwan1interface}".recovery_loss="$Cwan1recovery_loss"
						else
							uci delete mwan3."${cellularwan1interface}".failure_latency
							uci delete mwan3."${cellularwan1interface}".recovery_latency
							uci delete mwan3."${cellularwan1interface}".failure_loss
							uci delete mwan3."${cellularwan1interface}".recovery_loss	
						fi	
					else
						uci delete mwan3."${cellularwan1interface}".timeout
						uci delete mwan3."${cellularwan1interface}".interval
						uci delete mwan3."${cellularwan1interface}".check_quality
						uci delete mwan3."${cellularwan1interface}".failure_latency
						uci delete mwan3."${cellularwan1interface}".recovery_latency
						uci delete mwan3."${cellularwan1interface}".failure_loss
						uci delete mwan3."${cellularwan1interface}".recovery_loss	
					fi
	       fi
	        
	        #IPV6 update for sssm			
			if [ "$PDP1" = "IPV6" ] 
			then 
					uci delete mwan3.${cellularwan6sim1interface}_failover > /dev/null 2>&1
					uci delete mwan3."$cellularwan6sim1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan6sim1interface".track_ip)
					uci del_list mwan3."$cellularwan6sim1interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.failover.use_member="${cellularwan6sim1interface}_failover"
					
			         #member
					 uci set mwan3.${cellularwan6sim1interface}_failover=member
					 uci set mwan3.${cellularwan6sim1interface}_failover.interface="$cellularwan6sim1interface"
					 uci set mwan3.${cellularwan6sim1interface}_failover.metric="$Cwan6sim1Priority"
     
	                 #adding members under policy
	                 uci add_list mwan3.failover.use_member="${cellularwan6sim1interface}_failover"
	            
					 uci set mwan3."$cellularwan6sim1interface"=interface
					 uci set mwan3."$cellularwan6sim1interface".enabled="$Cwan6sim1Enabled"
                     uci set mwan3."$cellularwan6sim1interface".track_method="$Cwan6sim1trackmethod"
                
                     if [ "$Cwan6sim1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan6sim1interface".family="ipv4"
	                 uci set mwan3."$cellularwan6sim1interface".reliability="$Cwan6sim1Reliability"
	                 uci set mwan3."$cellularwan6sim1interface".count="$Cwan6sim1Count"
	                 uci set mwan3."$cellularwan6sim1interface".timeout="2"
	                 uci set mwan3."$cellularwan6sim1interface".down="$Cwan6sim1Down"
	                 uci set mwan3."$cellularwan6sim1interface".up="$Cwan6sim1Up"
	                           
	                 if [ "$Cwan6sim1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan6sim1advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan6sim1interface}".timeout="$Cwan6sim1timeout"
						uci set mwan3."${cellularwan6sim1interface}".interval="$Cwan6sim1interval"
						uci set mwan3."${cellularwan6sim1interface}".check_quality="$Cwan6sim1check_quality"
						if [ "$Cwan6sim1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan6sim1interface}".failure_latency="$Cwan6sim1failure_latency"
							uci set mwan3."${cellularwan6sim1interface}".recovery_latency="$Cwan6sim1recovery_latency"
							uci set mwan3."${cellularwan6sim1interface}".failure_loss="$Cwan6sim1failure_loss"
							uci set mwan3."${cellularwan6sim1interface}".recovery_loss="$Cwan6sim1recovery_loss"
						else
							uci delete mwan3."${cellularwan6sim1interface}".failure_latency
							uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
							uci delete mwan3."${cellularwan6sim1interface}".failure_loss
							uci delete mwan3."${cellularwan6sim1interface}".recovery_loss
						fi
					 else
						uci delete mwan3."${cellularwan6sim1interface}".timeout
						uci delete mwan3."${cellularwan6sim1interface}".interval
						uci delete mwan3."${cellularwan6sim1interface}".check_quality
						uci delete mwan3."${cellularwan6sim1interface}".failure_latency
						uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
						uci delete mwan3."${cellularwan6sim1interface}".failure_loss
						uci delete mwan3."${cellularwan6sim1interface}".recovery_loss	
					 fi
			   fi
		fi
		
  else
			uci delete mwan3.CWAN1_0_failover> /dev/null 2>&1
			uci delete mwan3.CWAN1_1_failover > /dev/null 2>&1
			uci delete mwan3.CWAN1_failover > /dev/null 2>&1
			uci delete mwan3.CWAN2_failover > /dev/null 2>&1
			uci delete mwan3.wan6c1_failover > /dev/null 2>&1
			uci delete mwan3.wan6c2_failover > /dev/null 2>&1
			
			uci delete mwan3.CWAN1_0 > /dev/null 2>&1
			uci delete mwan3.CWAN1_1 > /dev/null 2>&1
			uci delete mwan3.CWAN1 > /dev/null 2>&1
			uci delete mwan3.CWAN2 > /dev/null 2>&1
			uci delete mwan3.wan6c1 > /dev/null 2>&1
			uci delete mwan3.wan6c2 > /dev/null 2>&1
		fi
	uci commit mwan3
  fi	
	
}

UpdateMwanConfig_LoadBalancing()
{
  if [ "$Select" =  "balanced" ]
  then		
	echo "..."
	
	      #Default Rule V4
      uci set mwan3.default_rule_v4=rule
      uci set mwan3.default_rule_v4.dest_ip='0.0.0.0/0'
      uci set mwan3.default_rule_v4.family='ipv4'
      uci set mwan3.default_rule_v4.use_policy='balanced'

	  #Default Rule V6
      uci set mwan3.default_rule_v6=rule
      uci set mwan3.default_rule_v6.dest_ip='::/0'
      uci set mwan3.default_rule_v6.family='ipv6'
      uci set mwan3.default_rule_v6.use_policy='balanced'     
 
	  #policy for both V4 and V6
      uci set mwan3.balanced=policy
      uci set mwan3.balanced.last_resort='default'
	
		config_get NameCwan1 "$cellularwan1interface" name
		config_get Cwan1Weight "$cellularwan1interface" wanweight
		config_get Cwan1Enabled "$cellularwan1interface" enabled
        config_get Cwan1trackmethod "$cellularwan1interface" track_method	
	    config_get Cwan1TrackIp1 "$cellularwan1interface" trackIp1
		config_get Cwan1TrackIp2 "$cellularwan1interface" trackIp2
		config_get Cwan1TrackIp3 "$cellularwan1interface" trackIp3
		config_get Cwan1TrackIp4 "$cellularwan1interface" trackIp4
		config_get Cwan1Reliability "$cellularwan1interface" reliability
		config_get Cwan1Count "$cellularwan1interface" count
		config_get Cwan1Up "$cellularwan1interface" up
		config_get Cwan1Down "$cellularwan1interface" down
		config_get Cwan1validtrackip "$cellularwan1interface" validtrackip
		config_get Cwan1flush_conntrack "$cellularwan1interface" flush_conntrack
		config_get Cwan1advance_settings "$cellularwan1interface" advance_settings
		config_get Cwan1timeout "$cellularwan1interface" timeout
		config_get Cwan1interval "$cellularwan1interface" interval
		config_get Cwan1check_quality "$cellularwan1interface" check_quality
		config_get Cwan1failure_latency "$cellularwan1interface" failure_latency
	    config_get Cwan1recovery_latency "$cellularwan1interface" recovery_latency
		config_get Cwan1failure_loss "$cellularwan1interface" failure_loss
		config_get Cwan1recovery_loss "$cellularwan1interface" recovery_loss
		
   
		config_get NameCwan2 "$cellularwan2interface" name
		config_get Cwan2Weight "$cellularwan2interface" wanweight
		config_get Cwan2trackmethod "$cellularwan2interface" track_method
		config_get Cwan2TrackIp1 "$cellularwan2interface" trackIp1
		config_get Cwan2TrackIp2 "$cellularwan2interface" trackIp2
		config_get Cwan2TrackIp3 "$cellularwan2interface" trackIp3
		config_get Cwan2TrackIp4 "$cellularwan2interface" trackIp4
		config_get Cwan2flush_conntrack "$cellularwan2interface" flush_conntrack
		config_get Cwan2advance_settings "$cellularwan2interface" advance_settings
		config_get Cwan2timeout "$cellularwan2interface" timeout
		config_get Cwan2interval "$cellularwan2interface" interval
		config_get Cwan2check_quality "$cellularwan2interface" check_quality
		config_get Cwan2failure_latency "$cellularwan2interface" failure_latency
	    config_get Cwan2recovery_latency "$cellularwan2interface" recovery_latency
		config_get Cwan2failure_loss "$cellularwan2interface" failure_loss
		config_get Cwan2recovery_loss "$cellularwan2interface" recovery_loss
   
		config_get NameCwansim1 "$cellularwan1sim1interface" name
		config_get Cwan1sim1Weight "$cellularwan1sim1interface" wanweight
		config_get Cwan1sim1Enabled "$cellularwan1sim1interface" enabled
		config_get Cwan1sim1trackmethod "$cellularwan1sim1interface" track_method
        config_get Cwan1sim1TrackIp1 "$cellularwan1sim1interface" trackIp1
		config_get Cwan1sim1TrackIp2 "$cellularwan1sim1interface" trackIp2
		config_get Cwan1sim1TrackIp3 "$cellularwan1sim1interface" trackIp3
		config_get Cwan1sim1TrackIp4 "$cellularwan1sim1interface" trackIp4
		config_get Cwan1sim1Reliability "$cellularwan1sim1interface" reliability
		config_get Cwan1sim1Count "$cellularwan1sim1interface" count
		config_get Cwan1sim1Up "$cellularwan1sim1interface" up
		config_get Cwan1sim1Down "$cellularwan1sim1interface" down
		config_get Cwan1sim1validtrackip "$cellularwan1sim1interface" validtrackip
		config_get Cwan1sim1flush_conntrack "$cellularwan1sim1interface" flush_conntrack
		config_get Cwan1sim1advance_settings "$cellularwan1sim1interface" advance_settings
		config_get Cwan1sim1timeout "$cellularwan1sim1interface" timeout
		config_get Cwan1sim1interval "$cellularwan1sim1interface" interval
		config_get Cwan1sim1check_quality "$cellularwan1sim1interface" check_quality
		config_get Cwan1sim1failure_latency "$cellularwan1sim1interface" failure_latency
	    config_get Cwan1sim1recovery_latency "$cellularwan1sim1interface" recovery_latency
		config_get Cwan1sim1failure_loss "$cellularwan1sim1interface" failure_loss
		config_get Cwan1sim1recovery_loss "$cellularwan1sim1interface" recovery_loss
   
		config_get NameCwansim2 "$cellularwan1sim2interface" name
		config_get Cwan1sim2Weight "$cellularwan1sim2interface" wanweight
		config_get Cwan1sim2Enabled "$cellularwan1sim2interface" enabled
        config_get Cwan1sim2trackmethod "$cellularwan1sim2interface" track_method
		config_get Cwan1sim2TrackIp1 "$cellularwan1sim2interface" trackIp1
		config_get Cwan1sim2TrackIp2 "$cellularwan1sim2interface" trackIp2
		config_get Cwan1sim2TrackIp3 "$cellularwan1sim2interface" trackIp3
		config_get Cwan1sim2TrackIp4 "$cellularwan1sim2interface" trackIp4
		config_get Cwan1sim2Reliability "$cellularwan1sim2interface" reliability
		config_get Cwan1sim2Count "$cellularwan1sim2interface" count
		config_get Cwan1sim2Up "$cellularwan1sim2interface" up
		config_get Cwan1sim2Down "$cellularwan1sim2interface" down
		config_get Cwan1sim2validtrackip "$cellularwan1sim2interface" validtrackip
		config_get Cwan1sim2flush_conntrack "$cellularwan1sim2interface" flush_conntrack
		config_get Cwan1sim2advance_settings "$cellularwan1sim2interface" advance_settings
		config_get Cwan1sim2timeout "$cellularwan1sim2interface" timeout
		config_get Cwan1sim2interval "$cellularwan1sim2interface" interval
		config_get Cwan1sim2check_quality "$cellularwan1sim2interface" check_quality
		config_get Cwan1sim2failure_latency "$cellularwan1sim2interface" failure_latency
	    config_get Cwan1sim2recovery_latency "$cellularwan1sim2interface" recovery_latency
		config_get Cwan1sim2failure_loss "$cellularwan1sim2interface" failure_loss
		config_get Cwan1sim2recovery_loss "$cellularwan1sim2interface" recovery_loss
	
		#IPV6 variables
		config_get NameCwan6sim1 "$cellularwan6sim1interface" name
		config_get Cwan6sim1Weight "$cellularwan6sim1interface" wanweight
		config_get Cwan6sim1Enabled "$cellularwan6sim1interface" enabled
        config_get Cwan6sim1trackmethod "$cellularwan6sim1interface" track_method
		config_get Cwan6sim1TrackIp1 "$cellularwan6sim1interface" trackIp1
		config_get Cwan6sim1TrackIp2 "$cellularwan6sim1interface" trackIp2
		config_get Cwan6sim1TrackIp3 "$cellularwan6sim1interface" trackIp3
		config_get Cwan6sim1TrackIp4 "$cellularwan6sim1interface" trackIp4
		config_get Cwan6sim1Reliability "$cellularwan6sim1interface" reliability
		config_get Cwan6sim1Count "$cellularwan6sim1interface" count
		config_get Cwan6sim1Up "$cellularwan6sim1interface" up
		config_get Cwan6sim1Down "$cellularwan6sim1interface" down
		config_get Cwan6sim1validtrackip "$cellularwan6sim1interface" validtrackip
		config_get Cwan6sim1flush_conntrack "$cellularwan6sim1interface" flush_conntrack
		config_get Cwan6sim1advance_settings "$cellularwan6sim1interface" advance_settings
		config_get Cwan6sim1timeout "$cellularwan6sim1interface" timeout
		config_get Cwan6sim1interval "$cellularwan6sim1interface" interval
		config_get Cwan6sim1check_quality "$cellularwan6sim1interface" check_quality
		config_get Cwan6sim1failure_latency "$cellularwan6sim1interface" failure_latency
	    config_get Cwan6sim1recovery_latency "$cellularwan6sim1interface" recovery_latency
		config_get Cwan6sim1failure_loss "$cellularwan6sim1interface" failure_loss
		config_get Cwan6sim1recovery_loss "$cellularwan6sim1interface" recovery_loss
   
		config_get NameCwan6sim2 "$cellularwan6sim2interface" name
		config_get Cwan6sim2Weight "$cellularwan6sim2interface" wanweight
		config_get Cwan6sim2Enabled "$cellularwan6sim2interface" enabled
        config_get Cwan6sim2trackmethod "$cellularwan6sim2interface" track_method
		config_get Cwan6sim2TrackIp1 "$cellularwan6sim2interface" trackIp1
		config_get Cwan6sim2TrackIp2 "$cellularwan6sim2interface" trackIp2
		config_get Cwan6sim2TrackIp3 "$cellularwan6sim2interface" trackIp3
		config_get Cwan6sim2TrackIp4 "$cellularwan6sim2interface" trackIp4
		config_get Cwan6sim2Reliability "$cellularwan6sim2interface" reliability
		config_get Cwan6sim2Count "$cellularwan6sim2interface" count
		config_get Cwan6sim2Up "$cellularwan6sim2interface" up
		config_get Cwan6sim2Down "$cellularwan6sim2interface" down
		config_get Cwan6sim2validtrackip "$cellularwan6sim2interface" validtrackip
		config_get Cwan6sim2flush_conntrack "$cellularwan6sim2interface" flush_conntrack
		config_get Cwan6sim2advance_settings "$cellularwan6sim2interface" advance_settings
		config_get Cwan6sim2timeout "$cellularwan6sim2interface" timeout
		config_get Cwan6sim2interval "$cellularwan6sim2interface" interval
		config_get Cwan6sim2check_quality "$cellularwan6sim2interface" check_quality
		config_get Cwan6sim2failure_latency "$cellularwan6sim2interface" failure_latency
	    config_get Cwan6sim2recovery_latency "$cellularwan6sim2interface" recovery_latency
		config_get Cwan6sim2failure_loss "$cellularwan6sim2interface" failure_loss
		config_get Cwan6sim2recovery_loss "$cellularwan6sim2interface" recovery_loss
	  
		config_get NameWifiWan "$wifista" name
		config_get WifiWanWeight "$wifista" wanweight
		config_get WifiWanEnabled "$wifista" enabled
        config_get WifiWantrackmethod "$wifista" track_method
		config_get WifiWanTrackIp1 "$wifista" trackIp1
		config_get WifiWanTrackIp2 "$wifista" trackIp2
		config_get WifiWanTrackIp3 "$wifista" trackIp3
		config_get WifiWanTrackIp4 "$wifista" trackIp4
		config_get WifiWanReliability "$wifista" reliability
		config_get WifiWanCount "$wifista" count
		config_get WifiWanUp "$wifista" up
		config_get WifiWanDown "$wifista" down
		config_get WifiWanvalidtrackip "$wifista" validtrackip
		config_get WifiWanflush_conntrack "$wifista" flush_conntrack
		config_get WifiWanadvance_settings "$wifista" advance_settings
		config_get WifiWantimeout "$wifista" timeout
		config_get WifiWaninterval "$wifista" interval
		config_get WifiWancheck_quality "$wifista" check_quality
		config_get WifiWanfailure_latency "$wifista" failure_latency
	    config_get WifiWanrecovery_latency "$wifista" recovery_latency
		config_get WifiWanfailure_loss "$wifista" failure_loss
		config_get WifiWanrecovery_loss "$wifista" recovery_loss
		config_get WifiWaninitial_state "$wifista" initial_state

	    #uci delete mwan3."${cellularwan1interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan2interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan3interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan1sim1interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan1sim2interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan6sim1interface}" > /dev/null 2>&1
		#uci delete mwan3."${cellularwan6sim2interface}" > /dev/null 2>&1
		
		uci delete mwan3.CWAN1 > /dev/null 2>&1
		uci delete mwan3.CWAN2 > /dev/null 2>&1
		uci delete mwan3.CWAN1_0 > /dev/null 2>&1
		uci delete mwan3.CWAN1_1 > /dev/null 2>&1
		uci delete mwan3.WIFI_WAN > /dev/null 2>&1
		uci delete mwan3.wan6c1 > /dev/null 2>&1
		uci delete mwan3.wan6c2 > /dev/null 2>&1
		
		
	    uci delete mwan3."${wifista}" > /dev/null 2>&1
		uci delete mwan3.CWAN1_balanced > /dev/null 2>&1
		uci delete mwan3.CWAN2_balanced > /dev/null 2>&1
		uci delete mwan3.CWAN3_balanced > /dev/null 2>&1
		uci delete mwan3.CWAN1_0_balanced > /dev/null 2>&1
		uci delete mwan3.CWAN1_1_balanced > /dev/null 2>&1
		uci delete mwan3.wan6c1_balanced > /dev/null 2>&1
		uci delete mwan3.wan6c2_balanced > /dev/null 2>&1
		uci delete mwan3.WIFI_WAN_balanced > /dev/null 2>&1
		
	if [ "$Wifi1Enable" = "1" ]
	then 
		#apsta
		if [ "$Wifi1Mode" = "sta" ] ||  [ "$Wifi1Mode" = "apsta" ] 
		then 
				 uci delete mwan3.${wifista}_balanced > /dev/null 2>&1
			     uci delete mwan3."$wifista" > /dev/null 2>&1
			     delete_trackip=$(uci get mwan3."$wifista".track_ip)
                 uci del_list mwan3."$wifista".track_ip="$delete_trackip" 
			     
			     uci del_list mwan3.balanced.use_member="${wifista}_balanced"
			     
			         #member
					 uci set mwan3.${wifista}_balanced=member
					 uci set mwan3.${wifista}_balanced.interface="$wifista"
					 uci set mwan3.${wifista}_balanced.weight="$WifiWanWeight"
					 uci set mwan3.${wifista}_balanced.metric="1"
					 
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${wifista}_balanced"
	            
					 uci set mwan3."$wifista"=interface
					 uci set mwan3."$wifista".enabled="$WifiWanEnabled"
                     uci set mwan3."$wifista".track_method="$WifiWantrackmethod"
                
                     if [ "$WifiWanvalidtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
					 fi
					 if [ "$WifiWanvalidtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
		             uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp2"
					 fi
					 if [ "$WifiWanvalidtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp2"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp3"
					 fi
					 if [ "$WifiWanvalidtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp1"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp2"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp3"
						 uci add_list mwan3."$wifista".track_ip="$WifiWanTrackIp4"
					 fi
	                 uci set mwan3."$wifista".family="ipv4"
	                 uci set mwan3."$wifista".reliability="$WifiWanReliability"
	                 uci set mwan3."$wifista".count="$WifiWanCount"
	                 uci set mwan3."$wifista".timeout="2"
	                 uci set mwan3."$wifista".down="$WifiWanDown"
	                 uci set mwan3."$wifista".up="$WifiWanUp"
	                 
	                 if [ "$WifiWanflush_conntrack" = "1" ]
					then
						uci add_list mwan3."${wifista}".flush_conntrack="ifup"
						uci add_list mwan3."${wifista}".flush_conntrack="ifdown"
						uci add_list mwan3."${wifista}".flush_conntrack="connected"
						uci add_list mwan3."${wifista}".flush_conntrack="disconnected"
					else
						uci del_list mwan3."${wifista}".flush_conntrack="ifup"
						uci del_list mwan3."${wifista}".flush_conntrack="ifdown"
						uci del_list mwan3."${wifista}".flush_conntrack="connected"
						uci del_list mwan3."${wifista}".flush_conntrack="disconnected"
					fi
					
					if [ "$WifiWaninitial_state" = "1" ]
					then
						uci set mwan3."${wifista}".initial_state="offline"
					fi
					
					if [ "$WifiWanadvance_settings" =  "1" ]
					then 
						uci set mwan3."${wifista}".timeout="$WifiWantimeout"
						uci set mwan3."${wifista}".interval="$WifiWaninterval"
						uci set mwan3."${wifista}".check_quality="$WifiWancheck_quality"
						if [ "$WifiWancheck_quality" =  "1" ]
						then 
							uci set mwan3."${wifista}".failure_latency="$WifiWanfailure_latency"
							uci set mwan3."${wifista}".recovery_latency="$WifiWanrecovery_latency"
							uci set mwan3."${wifista}".failure_loss="$WifiWanfailure_loss"
							uci set mwan3."${wifista}".recovery_loss="$WifiWanrecovery_loss"
						else
							uci delete mwan3."${wifista}".failure_latency
							uci delete mwan3."${wifista}".recovery_latency
							uci delete mwan3."${wifista}".failure_loss
							uci delete mwan3."${wifista}".recovery_loss	
						fi
					else
						uci delete mwan3."${wifista}".timeout
						uci delete mwan3."${wifista}".interval
						uci delete mwan3."${wifista}".check_quality
						uci delete mwan3."${wifista}".failure_latency
						uci delete mwan3."${wifista}".recovery_latency
						uci delete mwan3."${wifista}".failure_loss
						uci delete mwan3."${wifista}".recovery_loss	
					fi
	        
	    else
			uci delete mwan3.WIFI_WAN_balanced > /dev/null 2>&1
			uci delete mwan3.WIFI_WAN
		fi
	 fi
	
	if [ "$EnableCellular" = "1" ]
		then
			if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
			then
			
				uci delete mwan3.CWAN1_1_balanced > /dev/null 2>&1
				uci delete mwan3.CWAN1_0_balanced > /dev/null 2>&1
				uci delete mwan3.wan6c1_balanced > /dev/null 2>&1
				uci delete mwan3.wan6c2_balanced > /dev/null 2>&1   
				
				uci delete mwan3.CWAN1_0
				uci delete mwan3.CWAN1_1
				uci delete mwan3.wan6c1
				uci delete mwan3.wan6c2
				
					uci delete mwan3.${cellularwan1interface}_balanced > /dev/null 2>&1
					uci delete mwan3."$cellularwan1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1interface".track_ip)
					uci del_list mwan3."$cellularwan1interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan1interface}_balanced"
			     
			         #member
					 uci set mwan3.${cellularwan1interface}_balanced=member
					 uci set mwan3.${cellularwan1interface}_balanced.interface="$cellularwan1interface"
					 uci set mwan3.${cellularwan1interface}_balanced.weight="$Cwan1Weight"
					 uci set mwan3.${cellularwan1interface}_balanced.metric="1"
     
	                 #adding members under policy
	                 uci add_list mwan3._balanced.use_member="${cellularwan1interface}__balanced"
	            
					 uci set mwan3."$cellularwan1interface"=interface
					 uci set mwan3."$cellularwan1interface".enabled="$Cwan1Enabled"
                     uci set mwan3."$cellularwan1interface".track_method="$Cwan1trackmethod"
                
                     if [ "$Cwan1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
					 fi
					 if [ "$Cwan1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
					 fi
					 if [ "$Cwan1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
					 fi
					 if [ "$Cwan1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1interface".family="ipv4"
	                 uci set mwan3."$cellularwan1interface".reliability="$Cwan1Reliability"
	                 uci set mwan3."$cellularwan1interface".count="$Cwan1Count"
	                 uci set mwan3."$cellularwan1interface".timeout="2"
	                 uci set mwan3."$cellularwan1interface".down="$Cwan1Down"
	                 uci set mwan3."$cellularwan1interface".up="$Cwan1Up"
	           
	                 if [ "$Cwan1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1interface".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan1interface}".flush_conntrack="disconnected"
					else
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="ifup"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="ifdown"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="connected"
						uci del_list mwan3."${cellularwan1interface}".flush_conntrack="disconnected"	 
					 fi
					 
					if [ "$Cwan1advance_settings" =  "1" ]
					then 
						uci set mwan3."${cellularwan1interface}".timeout="$Cwan1timeout"
						uci set mwan3."${cellularwan1interface}".interval="$Cwan1interval"
						uci set mwan3."${cellularwan1interface}".check_quality="$Cwan1check_quality"
						if [ "$Cwan1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan1interface}".failure_latency="$Cwan1failure_latency"
							uci set mwan3."${cellularwan1interface}".recovery_latency="$Cwan1recovery_latency"
							uci set mwan3."${cellularwan1interface}".failure_loss="$Cwan1failure_loss"
							uci set mwan3."${cellularwan1interface}".recovery_loss="$Cwan1recovery_loss"
						else
							uci delete mwan3."${cellularwan1interface}".failure_latency
							uci delete mwan3."${cellularwan1interface}".recovery_latency
							uci delete mwan3."${cellularwan1interface}".failure_loss
							uci delete mwan3."${cellularwan1interface}".recovery_loss	
						fi	
					else
						uci delete mwan3."${cellularwan1interface}".timeout
						uci delete mwan3."${cellularwan1interface}".interval
						uci delete mwan3."${cellularwan1interface}".check_quality
						uci delete mwan3."${cellularwan1interface}".failure_latency
						uci delete mwan3."${cellularwan1interface}".recovery_latency
						uci delete mwan3."${cellularwan1interface}".failure_loss
						uci delete mwan3."${cellularwan1interface}".recovery_loss	
					fi
	
					uci delete mwan3.${cellularwan2interface}_balanced > /dev/null 2>&1
					uci delete mwan3."$cellularwan2interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan2interface".track_ip)
					uci del_list mwan3."$cellularwan2interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan2interface}_balanced"
			     
			         #member
					 uci set mwan3.${cellularwan2interface}_balanced=member
					 uci set mwan3.${cellularwan2interface}_balanced.interface="$cellularwan2interface"
					 uci set mwan3.${cellularwan2interface}_balanced.weight="$Cwan2Weight"
					 uci set mwan3.${cellularwan2interface}_balanced.metric="1"
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${cellularwan2interface}_balanced"
	            
					 uci set mwan3."$cellularwan2interface"=interface
					 uci set mwan3."$cellularwan2interface".enabled="$Cwan2Enabled"
                     uci set mwan3."$cellularwan2interface".track_method="$Cwan2trackmethod"
                
                     if [ "$Cwan2validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
					 fi
					 if [ "$Cwan2validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
		             uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp2"
					 fi
					 if [ "$Cwan2validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp2"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp3"
					 fi
					 if [ "$Cwan2validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp1"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp2"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp3"
						 uci add_list mwan3."$cellularwan2interface".track_ip="$Cwan2TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan2interface".family="ipv4"
	                 uci set mwan3."$cellularwan2interface".reliability="$Cwan2Reliability"
	                 uci set mwan3."$cellularwan2interface".count="$Cwan2Count"
	                 uci set mwan3."$cellularwan2interface".timeout="2"
	                 uci set mwan3."$cellularwan2interface".down="$Cwan2Down"
	                 uci set mwan3."$cellularwan2interface".up="$Cwan2Up"
	               
	                 if [ "$Cwan2flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan2interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan2interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan2advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan2interface}".timeout="$Cwan2timeout"
						uci set mwan3."${cellularwan2interface}".interval="$Cwan2interval"
						uci set mwan3."${cellularwan2interface}".check_quality="$Cwan2check_quality"
						if [ "$Cwan2check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan2interface}".failure_latency="$Cwan2failure_latency"
							uci set mwan3."${cellularwan2interface}".recovery_latency="$Cwan2recovery_latency"
							uci set mwan3."${cellularwan2interface}".failure_loss="$Cwan2failure_loss"
							uci set mwan3."${cellularwan2interface}".recovery_loss="$Cwan2recovery_loss"
						else
							uci delete mwan3."${cellularwan2interface}".failure_latency
							uci delete mwan3."${cellularwan2interface}".recovery_latency
							uci delete mwan3."${cellularwan2interface}".failure_loss
							uci delete mwan3."${cellularwan2interface}".recovery_loss	
						fi	
					 else
						uci delete mwan3."${cellularwan2interface}".timeout
						uci delete mwan3."${cellularwan2interface}".interval
						uci delete mwan3."${cellularwan2interface}".check_quality
						uci delete mwan3."${cellularwan2interface}".failure_latency
						uci delete mwan3."${cellularwan2interface}".recovery_latency
						uci delete mwan3."${cellularwan2interface}".failure_loss
						uci delete mwan3."${cellularwan2interface}".recovery_loss	
					 fi
	        
				
			elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
			then                    
				uci delete mwan3.CWAN1_balanced > /dev/null 2>&1
				uci delete mwan3.CWAN2_balanced > /dev/null 2>&1
				uci delete mwan3.wan6c1_balanced > /dev/null 2>&1
				uci delete mwan3.wan6c2_balanced > /dev/null 2>&1 
				
				uci delete mwan3.wan6c1
				uci delete mwan3.wan6c2
				uci delete mwan3.CWAN1
				uci delete mwan3.CWAN2
				
				#IPV4 sim1 valid trackip
				if [ "$PDP1" = "IPV4" ]  || [ "$PDP1" = "IPV4V6" ]
				then 
					uci delete mwan3.${cellularwan1sim1interface}_balanced > /dev/null 2>&1
				    uci delete mwan3."$cellularwan1sim1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1sim1interface".track_ip)
					uci del_list mwan3."$cellularwan1sim1interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan1sim1interface}_balanced"
			     
			         #member
					 uci set mwan3.${cellularwan1sim1interface}_balanced=member
					 uci set mwan3.${cellularwan1sim1interface}_balanced.interface="$cellularwan1sim1interface"
					 uci set mwan3.${cellularwan1sim1interface}_balanced.weight="$Cwan1sim1Weight"
					 uci set mwan3.${cellularwan1sim1interface}_balanced.metric="1"
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${cellularwan1sim1interface}_balanced"
	            
					 uci set mwan3."$cellularwan1sim1interface"=interface
					 uci set mwan3."$cellularwan1sim1interface".enabled="$Cwan1sim1Enabled"
                     uci set mwan3."$cellularwan1sim1interface".track_method="$Cwan1sim1trackmethod"
                
                     if [ "$Cwan1sim1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
					 fi
					 if [ "$Cwan1sim1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
		             uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp2"
					 fi
					 if [ "$Cwan1sim1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp2"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp3"
					 fi
					 if [ "$Cwan1sim1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp1"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp2"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp3"
						 uci add_list mwan3."$cellularwan1sim1interface".track_ip="$Cwan1sim1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1sim1interface".family="ipv4"
	                 uci set mwan3."$cellularwan1sim1interface".reliability="$Cwan1sim1Reliability"
	                 uci set mwan3."$cellularwan1sim1interface".count="$Cwan1sim1Count"
	                 uci set mwan3."$cellularwan1sim1interface".timeout="2"
	                 uci set mwan3."$cellularwan1sim1interface".down="$Cwan1sim1Down"
	                 uci set mwan3."$cellularwan1sim1interface".up="$Cwan1sim1Up"
	                  
	                 if [ "$Cwan1sim1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan1sim1interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan1sim1interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan1sim1advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan1sim1interface}".timeout="$Cwan1sim1timeout"
						uci set mwan3."${cellularwan1sim1interface}".interval="$Cwan1sim1interval"
						uci set mwan3."${cellularwan1sim1interface}".check_quality="$Cwan1sim1check_quality"
						if [ "$Cwan1sim1check_quality" =  "1" ]
						then 
							uci set mwan3."${cellularwan1sim1interface}".failure_latency="$Cwan1sim1failure_latency"
							uci set mwan3."${cellularwan1sim1interface}".recovery_latency="$Cwan1sim1recovery_latency"
							uci set mwan3."${cellularwan1sim1interface}".failure_loss="$Cwan1sim1failure_loss"
							uci set mwan3."${cellularwan1sim1interface}".recovery_loss="$Cwan1sim1recovery_loss"
						else
							uci delete mwan3."${cellularwan1sim1interface}".failure_latency
							uci delete mwan3."${cellularwan1sim1interface}".recovery_latency
							uci delete mwan3."${cellularwan1sim1interface}".failure_loss
							uci delete mwan3."${cellularwan1sim1interface}".recovery_loss	
						fi
					 else
						uci delete mwan3."${cellularwan1sim1interface}".timeout
						uci delete mwan3."${cellularwan1sim1interface}".interval
						uci delete mwan3."${cellularwan1sim1interface}".check_quality
						uci delete mwan3."${cellularwan1sim1interface}".failure_latency
						uci delete mwan3."${cellularwan1sim1interface}".recovery_latency
						uci delete mwan3."${cellularwan1sim1interface}".failure_loss
						uci delete mwan3."${cellularwan1sim1interface}".recovery_loss	
					 fi 
				fi
				
				#IPV4 sim2 valid trackip
				
				if [ "$PDP2" = "IPV4" ]  || [ "$PDP2" = "IPV4V6" ]
				then 
					uci delete mwan3.${cellularwan1sim2interface}_balanced > /dev/null 2>&1
				    uci delete mwan3."$cellularwan1sim2interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1sim2interface".track_ip)
					uci del_list mwan3."$cellularwan1sim2interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan1sim2interface}_balanced"
			     
			         #member
					 uci set mwan3.${cellularwan1sim2interface}_balanced=member
					 uci set mwan3.${cellularwan1sim2interface}_balanced.interface="$cellularwan1sim2interface"
					 uci set mwan3.${cellularwan1sim2interface}_balanced.weight="$Cwan1sim2Weight"
					 uci set mwan3.${cellularwan1sim2interface}_balanced.metric="1"
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${cellularwan1sim2interface}_balanced"
	            
					 uci set mwan3."$cellularwan1sim2interface"=interface
					 uci set mwan3."$cellularwan1sim2interface".enabled="$Cwan1sim2Enabled"
                     uci set mwan3."$cellularwan1sim2interface".track_method="$Cwan1sim2trackmethod"
                
                     if [ "$Cwan1sim2validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
					 fi
					 if [ "$Cwan1sim2validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
		             uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp2"
					 fi
					 if [ "$Cwan1sim2validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp2"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp3"
					 fi
					 if [ "$Cwan1sim2validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp1"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp2"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp3"
						 uci add_list mwan3."$cellularwan1sim2interface".track_ip="$Cwan1sim2TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1sim2interface".family="ipv4"
	                 uci set mwan3."$cellularwan1sim2interface".reliability="$Cwan1sim2Reliability"
	                 uci set mwan3."$cellularwan1sim2interface".count="$Cwan1sim2Count"
	                 uci set mwan3."$cellularwan1sim2interface".timeout="2"
	                 uci set mwan3."$cellularwan1sim2interface".down="$Cwan1sim2Down"
	                 uci set mwan3."$cellularwan1sim2interface".up="$Cwan1sim2Up"
	                
	                 if [ "$Cwan1sim2flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan1sim2interface}".flush_conntrack="disconnected"	
					else
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan1sim2interface}".flush_conntrack="disconnected"	
					
					 fi
					 
					 if [ "$Cwan1sim2advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan1sim2interface}".timeout="$Cwan1sim2timeout"
						uci set mwan3."${cellularwan1sim2interface}".interval="$Cwan1sim2interval"
						uci set mwan3."${cellularwan1sim2interface}".check_quality="$Cwan1sim2check_quality"
						if [ "$Cwan1sim2check_quality" =  "1" ]
						then 
							uci set mwan3."${cellularwan1sim2interface}".failure_latency="$Cwan1sim2failure_latency"
							uci set mwan3."${cellularwan1sim2interface}".recovery_latency="$Cwan1sim2recovery_latency"
							uci set mwan3."${cellularwan1sim2interface}".failure_loss="$Cwan1sim2failure_loss"
							uci set mwan3."${cellularwan1sim2interface}".recovery_loss="$Cwan1sim2recovery_loss"
						else
							uci delete mwan3."${cellularwan1sim2interface}".failure_latency
							uci delete mwan3."${cellularwan1sim2interface}".recovery_latency
							uci delete mwan3."${cellularwan1sim2interface}".failure_loss
							uci delete mwan3."${cellularwan1sim2interface}".recovery_loss
						fi
					 else
						uci delete mwan3."${cellularwan1sim2interface}".timeout
						uci delete mwan3."${cellularwan1sim2interface}".interval
						uci delete mwan3."${cellularwan1sim2interface}".check_quality
						uci delete mwan3."${cellularwan1sim2interface}".failure_latency
						uci delete mwan3."${cellularwan1sim2interface}".recovery_latency
						uci delete mwan3."${cellularwan1sim2interface}".failure_loss
						uci delete mwan3."${cellularwan1sim2interface}".recovery_loss	
					 fi
				fi
			
			
			#IPV6 update for sim1 and sim2
			
			if [ "$PDP1" = "IPV6" ]
			then 
					uci delete mwan3.${cellularwan6sim1interface}_balanced > /dev/null 2>&1
			        uci delete mwan3."$cellularwan6sim1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan6sim1interface".track_ip)
					uci del_list mwan3."$cellularwan6sim1interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan6sim1interface}_balanced"
			     
			         #member
					 uci set mwan3.${cellularwan6sim1interface}_balanced=member
					 uci set mwan3.${cellularwan6sim1interface}_balanced.interface="$cellularwan6sim1interface"
					 uci set mwan3.${cellularwan6sim1interface}_balanced.weight="$Cwan6sim1Weight"
					 uci set mwan3.${cellularwan6sim1interface}_balanced.metric="1"
					 
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${cellularwan6sim1interface}_balanced"
	            
					 uci set mwan3."$cellularwan6sim1interface"=interface
					 uci set mwan3."$cellularwan6sim1interface".enabled="$Cwan6sim1Enabled"
                     uci set mwan3."$cellularwan6sim1interface".track_method="$Cwan6sim1trackmethod"
                
                     if [ "$Cwan6sim1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan6sim1interface".family="ipv4"
	                 uci set mwan3."$cellularwan6sim1interface".reliability="$Cwan6sim1Reliability"
	                 uci set mwan3."$cellularwan6sim1interface".count="$Cwan6sim1Count"
	                 uci set mwan3."$cellularwan6sim1interface".timeout="2"
	                 uci set mwan3."$cellularwan6sim1interface".down="$Cwan6sim1Down"
	                 uci set mwan3."$cellularwan6sim1interface".up="$Cwan6sim1Up"
	                 
	                 if [ "$Cwan6sim1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan6sim1advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan6sim1interface}".timeout="$Cwan6sim1timeout"
						uci set mwan3."${cellularwan6sim1interface}".interval="$Cwan6sim1interval"
						uci set mwan3."${cellularwan6sim1interface}".check_quality="$Cwan6sim1check_quality"
						if [ "$Cwan6sim1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan6sim1interface}".failure_latency="$Cwan6sim1failure_latency"
							uci set mwan3."${cellularwan6sim1interface}".recovery_latency="$Cwan6sim1recovery_latency"
							uci set mwan3."${cellularwan6sim1interface}".failure_loss="$Cwan6sim1failure_loss"
							uci set mwan3."${cellularwan6sim1interface}".recovery_loss="$Cwan6sim1recovery_loss"
						else
							uci delete mwan3."${cellularwan6sim1interface}".failure_latency
							uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
							uci delete mwan3."${cellularwan6sim1interface}".failure_loss
							uci delete mwan3."${cellularwan6sim1interface}".recovery_loss
						fi
					 else
						uci delete mwan3."${cellularwan6sim1interface}".timeout
						uci delete mwan3."${cellularwan6sim1interface}".interval
						uci delete mwan3."${cellularwan6sim1interface}".check_quality
						uci delete mwan3."${cellularwan6sim1interface}".failure_latency
						uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
						uci delete mwan3."${cellularwan6sim1interface}".failure_loss
						uci delete mwan3."${cellularwan6sim1interface}".recovery_loss	
					 fi
			   fi
			
		       if [ "$PDP2" = "IPV6" ]
			   then  
					uci delete mwan3.${cellularwan6sim2interface}_balanced > /dev/null 2>&1
			        uci delete mwan3."$cellularwan6sim2interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan6sim2interface".track_ip)
					uci del_list mwan3."$cellularwan6sim2interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan6sim2interface}_balanced"
			     
			         #member
					 uci set mwan3.${cellularwan6sim2interface}_balanced=member
					 uci set mwan3.${cellularwan6sim2interface}_balanced.interface="$cellularwan6sim2interface"
					 uci set mwan3.${cellularwan6sim2interface}_balanced.weight="$Cwan6sim2Weight"
					 uci set mwan3.${cellularwan6sim2interface}_balanced.metric"1"
					 
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${cellularwan6sim2interface}_balanced"
	            
					 uci set mwan3."$cellularwan6sim2interface"=interface
					 uci set mwan3."$cellularwan6sim2interface".enabled="$Cwan6sim2Enabled"
                     uci set mwan3."$cellularwan6sim2interface".track_method="$Cwan6sim2trackmethod"
                
                     if [ "$Cwan6sim2validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
					 fi
					 if [ "$Cwan6sim2validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
		             uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp2"
					 fi
					 if [ "$Cwan6sim2validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp2"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp3"
					 fi
					 if [ "$Cwan6sim2validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp1"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp2"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp3"
						 uci add_list mwan3."$cellularwan6sim2interface".track_ip="$Cwan6sim2TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan6sim2interface".family="ipv4"
	                 uci set mwan3."$cellularwan6sim2interface".reliability="$Cwan6sim2Reliability"
	                 uci set mwan3."$cellularwan6sim2interface".count="$Cwan6sim2Count"
	                 uci set mwan3."$cellularwan6sim2interface".timeout="2"
	                 uci set mwan3."$cellularwan6sim2interface".down="$Cwan6sim2Down"
	                 uci set mwan3."$cellularwan6sim2interface".up="$Cwan6sim2Up"
	                 
	                 if [ "$Cwan6sim2flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan6sim2interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan6sim2interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan6sim2advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan6sim2interface}".timeout="$Cwan6sim2timeout"
						uci set mwan3."${cellularwan6sim2interface}".interval="$Cwan6sim2interval"
						uci set mwan3."${cellularwan6sim2interface}".check_quality="$Cwan6sim2check_quality"
						if [ "$Cwan6sim2check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan6sim2interface}".failure_latency="$Cwan6sim2failure_latency"
							uci set mwan3."${cellularwan6sim2interface}".recovery_latency="$Cwan6sim2recovery_latency"
							uci set mwan3."${cellularwan6sim2interface}".failure_loss="$Cwan6sim2failure_loss"
							uci set mwan3."${cellularwan6sim2interface}".recovery_loss="$Cwan6sim2recovery_loss"
						else
							uci delete mwan3."${cellularwan6sim2interface}".failure_latency
							uci delete mwan3."${cellularwan6sim2interface}".recovery_latency
							uci delete mwan3."${cellularwan6sim2interface}".failure_loss
							uci delete mwan3."${cellularwan6sim2interface}".recovery_loss	
						fi
					 else
						uci delete mwan3."${cellularwan6sim2interface}".timeout
						uci delete mwan3."${cellularwan6sim2interface}".interval
						uci delete mwan3."${cellularwan6sim2interface}".check_quality
						uci delete mwan3."${cellularwan6sim2interface}".failure_latency
						uci delete mwan3."${cellularwan6sim2interface}".recovery_latency
						uci delete mwan3."${cellularwan6sim2interface}".failure_loss
						uci delete mwan3."${cellularwan6sim2interface}".recovery_loss	
					 fi
			   fi
					
		 else
			 uci delete mwan3.CWAN1_0_balanced > /dev/null 2>&1
			 uci delete mwan3.CWAN1_1_balanced > /dev/null 2>&1  
			 uci delete mwan3.wan6c2_balanced > /dev/null 2>&1    
			 uci delete mwan3.wan6c1_balanced > /dev/null 2>&1     
			 uci delete mwan3.CWAN1_balanced > /dev/null 2>&1
			 uci delete mwan3.CWAN1_balanced > /dev/null 2>&1
			 
			 uci delete mwan3.CWAN1_0 > /dev/null 2>&1
			 uci delete mwan3.CWAN1_1 > /dev/null 2>&1
			 uci delete mwan3.CWAN1 > /dev/null 2>&1
			 uci delete mwan3.CWAN2 > /dev/null 2>&1
			 uci delete mwan3.wan6c1 > /dev/null 2>&1
			 uci delete mwan3.wan6c2 > /dev/null 2>&1
			
		   #IPV4 update			 
	       if [ "$PDP1" = "IPV4" ]  || [ "$PDP1" = "IPV4V6" ]
	       then 
					uci delete mwan3.${cellularwan1interface}_balanced > /dev/null 2>&1
					uci delete mwan3."$cellularwan1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan1interface".track_ip)
					uci del_list mwan3."$cellularwan1interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan1interface}_balanced"
			     
			         #member
					 uci set mwan3.${cellularwan1interface}_balanced=member
					 uci set mwan3.${cellularwan1interface}_balanced.interface="$cellularwan1interface"
					 uci set mwan3.${cellularwan1interface}_balanced.weight="$Cwan1Weight"
					 uci set mwan3.${cellularwan1interface}_balanced.metric="1"
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${cellularwan1interface}_balanced"
	            
					 uci set mwan3."$cellularwan1interface"=interface
					 uci set mwan3."$cellularwan1interface".enabled="$Cwan1Enabled"
                     uci set mwan3."$cellularwan1interface".track_method="$Cwan1trackmethod"
                
                     if [ "$Cwan1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
					 fi
					 if [ "$Cwan1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
		             uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
					 fi
					 if [ "$Cwan1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
					 fi
					 if [ "$Cwan1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp1"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp2"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp3"
						 uci add_list mwan3."$cellularwan1interface".track_ip="$Cwan1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan1interface".family="ipv4"
	                 uci set mwan3."$cellularwan1interface".reliability="$Cwan1Reliability"
	                 uci set mwan3."$cellularwan1interface".count="$Cwan1Count"
	                 uci set mwan3."$cellularwan1interface".timeout="2"
	                 uci set mwan3."$cellularwan1interface".down="$Cwan1Down"
	                 uci set mwan3."$cellularwan1interface".up="$Cwan1Up"
	                   
	                 if [ "$Cwan1advance_settings" =  "1" ]
					then 
						uci set mwan3."${cellularwan1interface}".timeout="$Cwan1timeout"
						uci set mwan3."${cellularwan1interface}".interval="$Cwan1interval"
						uci set mwan3."${cellularwan1interface}".check_quality="$Cwan1check_quality"
						if [ "$Cwan1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan1interface}".failure_latency="$Cwan1failure_latency"
							uci set mwan3."${cellularwan1interface}".recovery_latency="$Cwan1recovery_latency"
							uci set mwan3."${cellularwan1interface}".failure_loss="$Cwan1failure_loss"
							uci set mwan3."${cellularwan1interface}".recovery_loss="$Cwan1recovery_loss"
						else
							uci delete mwan3."${cellularwan1interface}".failure_latency
							uci delete mwan3."${cellularwan1interface}".recovery_latency
							uci delete mwan3."${cellularwan1interface}".failure_loss
							uci delete mwan3."${cellularwan1interface}".recovery_loss	
						fi	
					else
						uci delete mwan3."${cellularwan1interface}".timeout
						uci delete mwan3."${cellularwan1interface}".interval
						uci delete mwan3."${cellularwan1interface}".check_quality
						uci delete mwan3."${cellularwan1interface}".failure_latency
						uci delete mwan3."${cellularwan1interface}".recovery_latency
						uci delete mwan3."${cellularwan1interface}".failure_loss
						uci delete mwan3."${cellularwan1interface}".recovery_loss	
					fi
	       fi
	        
	        #IPV6 update for sssm			
			if [ "$PDP1" = "IPV6" ]
			then 
					uci delete mwan3.${cellularwan6sim1interface}_balanced > /dev/null 2>&1
					uci delete mwan3."$cellularwan6sim1interface" > /dev/null 2>&1
					delete_trackip=$(uci get mwan3."$cellularwan6sim1interface".track_ip)
					uci del_list mwan3."$cellularwan6sim1interface".track_ip="$delete_trackip" 
			     
					uci del_list mwan3.balanced.use_member="${cellularwan6sim1interface}_balanced"	
			     
			         #member
					 uci set mwan3.${cellularwan6sim1interface}_balanced=member
					 uci set mwan3.${cellularwan6sim1interface}_balanced.interface="$cellularwan6sim1interface"
					 uci set mwan3.${cellularwan6sim1interface}_balanced.weight="$Cwan6sim1Weight"
					 uci set mwan3.${cellularwan6sim1interface}_balanced.metric="1"
	                 #adding members under policy
	                 uci add_list mwan3.balanced.use_member="${cellularwan6sim1interface}_balanced"
	            
					 uci set mwan3."$cellularwan6sim1interface"=interface
					 uci set mwan3."$cellularwan6sim1interface".enabled="$Cwan6sim1Enabled"
                     uci set mwan3."$cellularwan6sim1interface".track_method="$Cwan6sim1trackmethod"
                
                     if [ "$Cwan6sim1validtrackip" =  "1" ]
	                 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "2" ]
					 then 
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
		             uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "3" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
					 fi
					 if [ "$Cwan6sim1validtrackip" =  "4" ]
					 then 
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp1"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp2"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp3"
						 uci add_list mwan3."$cellularwan6sim1interface".track_ip="$Cwan6sim1TrackIp4"
					 fi
	                 uci set mwan3."$cellularwan6sim1interface".family="ipv4"
	                 uci set mwan3."$cellularwan6sim1interface".reliability="$Cwan6sim1Reliability"
	                 uci set mwan3."$cellularwan6sim1interface".count="$Cwan6sim1Count"
	                 uci set mwan3."$cellularwan6sim1interface".timeout="2"
	                 uci set mwan3."$cellularwan6sim1interface".down="$Cwan6sim1Down"
	                 uci set mwan3."$cellularwan6sim1interface".up="$Cwan6sim1Up"
	                 
	                 if [ "$Cwan6sim1flush_conntrack" =  "1" ]
	                 then 
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci add_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					else
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifup"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="ifdown"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="connected"
						 uci del_list mwan3."${cellularwan6sim1interface}".flush_conntrack="disconnected"
					 fi
					 
					 if [ "$Cwan6sim1advance_settings" =  "1" ]
					 then 
						uci set mwan3."${cellularwan6sim1interface}".timeout="$Cwan6sim1timeout"
						uci set mwan3."${cellularwan6sim1interface}".interval="$Cwan6sim1interval"
						uci set mwan3."${cellularwan6sim1interface}".check_quality="$Cwan6sim1check_quality"
						if [ "$Cwan6sim1check_quality" =  "1" ]
						then
							uci set mwan3."${cellularwan6sim1interface}".failure_latency="$Cwan6sim1failure_latency"
							uci set mwan3."${cellularwan6sim1interface}".recovery_latency="$Cwan6sim1recovery_latency"
							uci set mwan3."${cellularwan6sim1interface}".failure_loss="$Cwan6sim1failure_loss"
							uci set mwan3."${cellularwan6sim1interface}".recovery_loss="$Cwan6sim1recovery_loss"
						else
							uci delete mwan3."${cellularwan6sim1interface}".failure_latency
							uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
							uci delete mwan3."${cellularwan6sim1interface}".failure_loss
							uci delete mwan3."${cellularwan6sim1interface}".recovery_loss
						fi
					 else
						uci delete mwan3."${cellularwan6sim1interface}".timeout
						uci delete mwan3."${cellularwan6sim1interface}".interval
						uci delete mwan3."${cellularwan6sim1interface}".check_quality
						uci delete mwan3."${cellularwan6sim1interface}".failure_latency
						uci delete mwan3."${cellularwan6sim1interface}".recovery_latency
						uci delete mwan3."${cellularwan6sim1interface}".failure_loss
						uci delete mwan3."${cellularwan6sim1interface}".recovery_loss	
					 fi
			   fi
		  fi
		
		else
			uci delete mwan3.CWAN1_0_balanced> /dev/null 2>&1
			uci delete mwan3.CWAN1_1_balanced > /dev/null 2>&1
			uci delete mwan3.CWAN1_balanced > /dev/null 2>&1
			uci delete mwan3.CWAN2_balanced > /dev/null 2>&1
			uci delete mwan3.wan6c1_balanced > /dev/null 2>&1
			uci delete mwan3.wan6c2_balanced > /dev/null 2>&1
			
			uci delete mwan3.CWAN1_0
			uci delete mwan3.CWAN1_1
			uci delete mwan3.CWAN1
			uci delete mwan3.CWAN2
			uci delete mwan3.wan6c1
			uci delete mwan3.wan6c2
	fi

	uci commit mwan3

  fi
}

UpdateWirelessConfig()
{
	    pid=$(pgrep -f "/root/InterfaceManager/script/Wifi_udhcpcmonitor.sh")
	    kill -9 $pid
		uci set wireless.ra0.country="$CountryCode"
		uci set wireless.ra0.channel="$WifiDevicesChannel"
		txpower=$(grep -w "TxPower" ${wirelessdatfile})        
		txpower_replace="TxPower=$TxPower"
		sed -i "s/${txpower}/${txpower_replace}/" "$wirelessdatfile"
		wmmenable=$(grep -w "WmmCapable" ${wirelessdatfile})        
		wmmenable_replace="WmmCapable=$WmmEnable"
		sed -i "s/${wmmenable}/${wmmenable_replace}/" "$wirelessdatfile"
		sed -i '/ScheduledWifiOff.sh/d' /etc/crontabs/root
		sed -i '/ScheduledWifiOn.sh/d' /etc/crontabs/root
		countrycode=$(grep -w "CountryCode" ${wirelessdatfile})        
		countrycode_replace="CountryCode=$CountryCode"
		sed -i "s/${countrycode}/${countrycode_replace}/" "$wirelessdatfile"
		ht_bw=$(grep -w "HT_BW" ${wirelessdatfile})        
		ht_bw_replace="HT_BW=$channelwidth"
		sed -i "s/${ht_bw}/${ht_bw_replace}/" "$wirelessdatfile" 
		channel=$(grep -w "Channel" ${wirelessdatfile})        
		Channel_replace="Channel=$WifiDevicesChannel"
		sed -i "s/${channel}/${Channel_replace}/" "$wirelessdatfile"
		   uci delete network."${wifiap}" > /dev/null 2>&1
		   uci delete network."${wifista}" > /dev/null 2>&1
		   uci delete network."${wifiap1}" > /dev/null 2>&1
		if [ "$Wifi1Enable" = "0" ]
		then 
		   uci set wireless.ap.disabled="1"
		   uci set wireless.sta.disabled="1"
		   uci delete network."${wifiap}" > /dev/null 2>&1
		   uci delete network."${wifista}" > /dev/null 2>&1
		   uci delete network."${wifiap1}" > /dev/null 2>&1
		else
			  if [ "$Wifi1Mode" = "ap" ]
			  then
				  ifdown apcli0
				  hidessid=$(grep -w "HideSSID" ${wirelessdatfile})        
				  hidessid_replace="HideSSID=0"
				  sed -i "s/${hidessid}/${hidessid_replace}/" "$wirelessdatfile"
				  uci delete  network."${wifiap}" > /dev/null 2>&1
				  uci delete  network."${wifista}" > /dev/null 2>&1
				  uci set wireless.sta.disabled="1"
				  uci set wireless.ap.disabled="0"
				  uci set wireless.ap.ssid="$Wifi1Ssid"
				  uci set wireless.ap.key="$Wifi1Key"
				  uci set wireless.ap.encryption="$wifi1encryption"
				  uci set network."${wifiap}"=interface
				  
				  uci set network."${wifiap}".ipaddr="$Radio0DhcpIp"
				  uci set network."${wifiap}".netmask="255.255.255.0"
				  uci set network."${wifiap}".proto="static"
				  uci set network."${wifiap}".ifname="ra0"
				  
				  uci set dhcp."${wifiap}"=dhcp
                  uci set dhcp."${wifiap}".interface="${wifiap}"
				  uci set dhcp."${wifiap}".start="$Radio0DHCPRange"
				  uci set dhcp."${wifiap}".limit="$Radio0DHCPLimit"
				  uci set dhcp."${wifiap}".leasetime="12h"
				  uci set dhcp."${wifiap}".dhcpv6="disabled"
				  uci set dhcp."${wifiap}".ra="disabled"
				  
				  ssid=$(grep -w "SSID1" ${wirelessdatfile})        
				  ssid_replace="SSID1=$Wifi1Ssid"
				  sed -i "s/${ssid}/${ssid_replace}/" "$wirelessdatfile"
				  
				  wpapsk1=$(grep -w "WPAPSK1" ${wirelessdatfile})        
				  wpapsk1_replace="WPAPSK1=$Wifi1Key"
				  sed -i "s/${wpapsk1}/${wpapsk1_replace}/" "$wirelessdatfile"
				  uci delete network.wan > /dev/null 2>&1

							authmode=$(grep -w "AuthMode" ${wirelessdatfile})        
							authmode_replace="AuthMode=$wifi1authentication"
							sed -i "s/${authmode}/${authmode_replace}/" "$wirelessdatfile"
							
							encryption=$(grep -w "EncrypType" ${wirelessdatfile})        
							encrypt_replace="EncrypType=$wifi1encryption"
							sed -i "s/${encryption}/${encrypt_replace}/" "$wirelessdatfile"           
					
					
				fi       
			

	
				  if [ "$Wifi1Mode" = "sta" ]
				  then
				      /root/InterfaceManager/script/Wifi_udhcpcmonitor.sh &			  		
					  iwpriv ra0 set HideSSID=1
					  iwpriv ra1 set HideSSID=1
					  hidessid=$(grep -w "HideSSID" ${wirelessdatfile})        
					  hidessid_replace="HideSSID=1"
					  sed -i "s/${hidessid}/${hidessid_replace}/" "$wirelessdatfile"
					  uci set wireless.sta.disabled="0"
					  uci set wireless.sta.ssid="$Wifi1StaSsid"
					  uci set wireless.sta.key="$Wifi1StaKey"
					  uci set wireless.sta.encryption="$Wifi1StaEncryption"
					  uci set network.WIFI_WAN=interface
					  uci set network.WIFI_WAN.proto="dhcp"
					  uci set network.WIFI_WAN.metric="$WifiWanPriority"
					  uci set network.WIFI_WAN.ifname="apcli0"
					 
					   if [ "$EnableDhcpRelay" = "1" ]
					  then
					   uci delete dhcp."${wifiap}"
				       echo "dhcp-relay=${Radio0DhcpIp},${WifiRelayServerIP}" >> /etc/dnsmasq.conf
				       #echo "dhcp-relay=${Radio0DhcpIp},${WifiRelayServerIP},${wifiap}" >> /etc/dnsmasq.conf
				       #uci set network."${wifiap}".ipaddr="$WifiRelayLocalIP"
				       #else
				       #uci delete network."${wifiap}".ipaddr="$WifiRelayLocalIP"    
				       fi
				  fi
		  
				  if [ "$guestwifienable" = "1" ]
				  then
						uci set network."${wifiap1}"=interface
						uci set network."${wifiap1}".ipaddr="$guestradio0dhcpip"
						uci set network."${wifiap1}".netmask="255.255.255.0"
						uci set network."${wifiap1}".proto="static"
						uci set network."${wifiap1}".ifname="ra1"
						uci set dhcp."${wifiap1}".start="$guestRadio0DHCPrange"
						uci set dhcp."${wifiap1}".limit="$guestRadio0DHCPlimit"
								
						ssid2=$(grep -w "SSID2" ${wirelessdatfile})        
						ssid2_replace="SSID2=$guestwifissid"
						sed -i "s/${ssid2}/${ssid2_replace}/" "$wirelessdatfile"
						
							authmode=$(grep -w "AuthMode" ${wirelessdatfile})        
							authmode_replace="AuthMode=$wifi1authentication;$guestwifi1authentication"
							sed -i "s/${authmode}/${authmode_replace}/" "$wirelessdatfile"
							
							encryption=$(grep -w "EncrypType" ${wirelessdatfile})        
							encrypt_replace="EncrypType=$wifi1encryption;$guestwifi1encryption"
							sed -i "s/${encryption}/${encrypt_replace}/" "$wirelessdatfile"
						
						wpapsk2=$(grep -w "WPAPSK2" ${wirelessdatfile})        
						wpapsk2_replace="WPAPSK2=$guestwifikey"
						sed -i "s/${wpapsk2}/${wpapsk2_replace}/" "$wirelessdatfile"
					else 
						uci delete  network.ra1 > /dev/null 2>&1
				  fi
		  
				  if [ "$Wifi1Mode" = "apsta" ]
				  then
						/root/InterfaceManager/script/Wifi_udhcpcmonitor.sh &			  		
						ssid=$(grep -w "SSID1" ${wirelessdatfile})        
						ssid_replace="SSID1=$Wifi1Ssid"
						sed -i "s/${ssid}/${ssid_replace}/" "$wirelessdatfile"

                        if [ "$guestwifienable" = "0" ];then
							authmode=$(grep -w "AuthMode" ${wirelessdatfile})        
							authmode_replace="AuthMode=$wifi1authentication"
							sed -i "s/${authmode}/${authmode_replace}/" "$wirelessdatfile"
						elif [ "$guestwifienable" = "1" ];then
							authmode=$(grep -w "AuthMode" ${wirelessdatfile})        
							authmode_replace="AuthMode=$wifi1authentication;$guestwifi1authentication"
							sed -i "s/${authmode}/${authmode_replace}/" "$wirelessdatfile"
						fi	
						
						 if [ "$guestwifienable" = "0" ];then
							encryption=$(grep -w "EncrypType" ${wirelessdatfile})        
							encrypt_replace="EncrypType=$wifi1encryption"
							sed -i "s/${encryption}/${encrypt_replace}/" "$wirelessdatfile"           
						elif [ "$guestwifienable" = "1" ];then
							encryption=$(grep -w "EncrypType" ${wirelessdatfile})        
							encrypt_replace="EncrypType=$wifi1encryption;$guestwifi1encryption"
							sed -i "s/${encryption}/${encrypt_replace}/" "$wirelessdatfile"
						fi   
                        wpapsk1=$(grep -w "WPAPSK1" ${wirelessdatfile})        
						wpapsk1_replace="WPAPSK1=$Wifi1Key"
						sed -i "s/${wpapsk1}/${wpapsk1_replace}/" "$wirelessdatfile"
                        
						hidessid=$(grep -w "HideSSID" ${wirelessdatfile})        
						hidessid_replace="HideSSID=0"
						sed -i "s/${hidessid}/${hidessid_replace}/" "$wirelessdatfile"
						uci set wireless.ap.disabled="0"
						uci set wireless.ap.ssid="$Wifi1Ssid"
						uci set wireless.ap.key="$Wifi1Key"
						uci set wireless.ap.encryption="$wifi1encryption"
						uci set network."${wifiap}"=interface
						uci set network."${wifiap}".ipaddr="$Radio0DhcpIp"
						uci set network."${wifiap}".netmask="255.255.255.0"
						uci set network."${wifiap}".proto="static"
						uci set network."${wifiap}".ifname="ra0"
						
					    uci set dhcp."${wifiap}"=dhcp
					    uci set dhcp."${wifiap}".interface="${wifiap}"
					    uci set dhcp."${wifiap}".start="$Radio0DHCPRange"
					    uci set dhcp."${wifiap}".limit="$Radio0DHCPLimit"
					    uci set dhcp."${wifiap}".leasetime="12h"
					    uci set dhcp."${wifiap}".dhcpv6="disabled"
				        uci set dhcp."${wifiap}".ra="disabled"
						
						
					   if [ "$EnableDhcpRelay" = "1" ]
					   then
					       uci delete dhcp."${wifiap}"
				           echo "dhcp-relay=${Radio0DhcpIp},${WifiRelayServerIP}" >> /etc/dnsmasq.conf
				           uci set network."${wifiap}".ipaddr="$Radio0DhcpIp"
				       fi
					  
						uci set wireless.sta.disabled="0"
						uci set wireless.sta.ssid="$Wifi1StaSsid"
						uci set wireless.sta.key="$Wifi1StaKey"
						uci set wireless.sta.encryption="$Wifi1StaEncryption"
						uci set network.WIFI_WAN=interface
						uci set network.WIFI_WAN.proto="dhcp"
						if [ "$Select" =  "failover" ]
						then
							uci set network.WIFI_WAN.metric="$WifiWanPriority"
						else 
							uci set network.WIFI_WAN.metric="1"
						fi	
						uci set network.WIFI_WAN.ifname="apcli0"           
				  fi
		fi
	uci commit wireless
	uci commit network
	uci commit dhcp
}

UpdateScheduledWifiOnOff()
{   
			CronReadListValuesMaintenanceReboot()
			{
				TmpVal=""
				local value="$1"
				local VarName="$2"
				TmpVal="$(eval echo '$'ListValue"$VarName")"
				eval ListValue"$VarName"="${TmpVal}${value},"
			
			}
			
	
			 if [ "$ScheduledOnOff" = "1" ]
			 then
				config_load "$SystemConfigFile"             
				config_list_foreach "wirelessconfig" fromHours CronReadListValuesMaintenanceReboot fromHours
				config_list_foreach "wirelessconfig" fromMinutes CronReadListValuesMaintenanceReboot fromMinutes
				config_list_foreach "wirelessconfig" toHours CronReadListValuesMaintenanceReboot toHours
				config_list_foreach "wirelessconfig" toMinutes CronReadListValuesMaintenanceReboot toMinutes
				config_list_foreach "wirelessconfig" DayOfMonth CronReadListValuesMaintenanceReboot DayOfMonth
				config_list_foreach "wirelessconfig" Month CronReadListValuesMaintenanceReboot Month
				config_list_foreach "wirelessconfig" DayOfWeek CronReadListValuesMaintenanceReboot DayOfWeek
			 fi

			
			ListValfromHours=$(echo "$ListValuefromHours" | sed s'/,$//')
			ListValfromMinutes=$(echo "$ListValuefromMinutes" | sed s'/,$//')
			ListValtoHours=$(echo "$ListValuetoHours" | sed s'/,$//')
			ListValtoMinutes=$(echo "$ListValuetoMinutes" | sed s'/,$//')
			ListValDayOfWeek=$(echo "$ListValueDayOfWeek" | sed s'/,$//')
			ListValDayOfMonth=$(echo "$ListValueDayOfMonth" | sed s'/,$//')
			ListValMonth=$(echo "$ListValueMonth" | sed s'/,$//')
			echo "$ListValfromMinutes $ListValfromHours * * $ListValDayOfWeek /root/InterfaceManager/script/ScheduledWifiOff.sh" >> /etc/crontabs/root
			echo "$ListValtoMinutes $ListValtoHours * * $ListValDayOfWeek /root/InterfaceManager/script/ScheduledWifiOn.sh" >> /etc/crontabs/root

	
}

UpdateModemConfig()
{
	Cwan1sim1Priority=$(uci get mwan3config."${cellularwan1sim1interface}".wanpriority)
	Cwan1sim2Priority=$(uci get mwan3config."${cellularwan1sim2interface}".wanpriority)
	Cwan1Priority=$(uci get mwan3config."${cellularwan1interface}".wanpriority)
	Cwan2Priority=$(uci get mwan3config."${cellularwan2interface}".wanpriority)
	Cwan3Priority=$(uci get mwan3config."${cellularwan3interface}".wanpriority)
	
	
	if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
	then
	   uci set modem.cellularmodule.singlesimsinglemodule="0"
	   uci set modem.cellularmodule.singlesimdualmodule="1"
	   uci set modem.cellularmodule.dualsimsinglemodule="0"
	   uci set modem."${cellularwan1interface}".modemenable="1"
	   uci set modem."${cellularwan1sim1interface}".modemenable="0"
	   uci set modem."${cellularwan1sim2interface}".modemenable="0"
	   uci set modem."${cellularwan2interface}".modemenable="1"
	   uci set modem."${cellularwan3interface}".modemenable="0"
	   uci set modem."${cellularwan1interface}".manufacturer="$Manufacturerlocal1"
	   uci set modem."${cellularwan1interface}".model="$Model1"
	   uci set modem."${cellularwan1interface}".porttype="$PortType1"
	   uci set modem."${cellularwan1interface}".vendorid="$VendorId1"
	   uci set modem."${cellularwan1interface}".productid="$ProductId1"
	   uci set modem."${cellularwan1interface}".device="$DataPort1"
	   uci set modem."${cellularwan1interface}".comport="$ComPort1"
	   uci set modem."${cellularwan1interface}".smsport="$SmsPort1"
	   uci set modem."${cellularwan1interface}".smsenable="$SmsEnable1"
	   uci set modem."${cellularwan1interface}".smsc="$SmsCenterNumber1"
	   uci set modem."${cellularwan1interface}".smsdeviceid="$DeviceId1"
	   uci set modem."${cellularwan1interface}".smsapikey="$ApiKey1"
	   uci set modem."${cellularwan1interface}".monitorenable="1"
	   uci set modem."${cellularwan1interface}".actionmanagerenable="$MonitorEnable1"
	   uci set modem."${cellularwan1interface}".analyticsmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1interface}".statusmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1interface}".datatestenable="$DataTestEnable1"
	   uci set modem."${cellularwan1interface}".pingtestenable="$PingTestEnable1"
	   uci set modem."${cellularwan1interface}".pingip="$PingIp1"
	   uci set modem."${cellularwan1interface}".dataenable="$DataEnable1"
	   uci set modem."${cellularwan1interface}".service="$Service1"
	   uci set modem."${cellularwan1interface}".apn="$Apn1"
	   if [ "$Select" =  "failover" ]
       then
	   uci set modem."${cellularwan1interface}".metric="$Cwan1Priority"
	   else
	   uci set modem."${cellularwan1interface}".metric="1"
	   fi
	   uci set modem."${cellularwan1interface}".usbbuspath="$UsbBusPath1"
	   uci set modem."${cellularwan1interface}".action1waitinterval="$ActionInterval1"
	   uci set modem."${cellularwan1interface}".mtu="$mtu"
	   if [ "$CellularModem1" = "QuectelEC20" ] || [ "$CellularModem1" = "QuectelEC25E" ]
	   then
	   uci set modem."${cellularwan1interface}".protocol="$Protocol1EC20"
	   if [ "$Protocol1EC20" == "ppp" ]
	   then
		 uci set modem."${cellularwan1interface}".interfacename="3g-CWAN1"
	   else
		 uci set modem."${cellularwan1interface}".interfacename="wwan0"
	   fi
	   else
	   uci set modem."${cellularwan1interface}".protocol="$Protocol1"
	   if [ "$Protocol1" == "ppp" ]
	   then
		 uci set modem."${cellularwan1interface}".interfacename="3g-CWAN1"
	   else
		 uci set modem."${cellularwan1interface}".interfacename="usb0"
	   fi
	   fi
	   uci set modem."${cellularwan1interface}".smsresponsesenderenable="$SmsResponseSenderEnable1"
	   uci set modem."${cellularwan1interface}".smsresponseserverenable="$SmsResponseServerEnable1"
	   uci set modem."${cellularwan1interface}".smsservernumber="$SmsServerNumber1"

	   if [ "$Pdp1" = "IPV4" ]
	   then
		   uci set modem."${cellularwan1interface}".ipv6="1"
	   fi
	   uci set modem."${cellularwan2interface}".manufacturer="$Manufacturerlocal2"
	   uci set modem."${cellularwan2interface}".model="$Model2"
	   uci set modem."${cellularwan2interface}".porttype="$PortType2"
	   uci set modem."${cellularwan2interface}".vendorid="$VendorId2"
	   uci set modem."${cellularwan2interface}".productid="$ProductId2"
	   uci set modem."${cellularwan2interface}".device="$DataPort2"
	   uci set modem."${cellularwan2interface}".comport="$ComPort2"
	   uci set modem."${cellularwan2interface}".smsport="$SmsPort2"
	   uci set modem."${cellularwan2interface}".smsenable="$SmsEnable2"
	   uci set modem."${cellularwan2interface}".smsc="$SmsCenterNumber2"
	   uci set modem."${cellularwan2interface}".smsdeviceid="$DeviceId2"
	   uci set modem."${cellularwan2interface}".smsapikey="$ApiKey2"
	   uci set modem."${cellularwan2interface}".monitorenable="1"
	   uci set modem."${cellularwan2interface}".actionmanagerenable="$MonitorEnable2"
	   uci set modem."${cellularwan2interface}".analyticsmanagerenable="$QueryModematAnalytics2"
	   uci set modem."${cellularwan2interface}".statusmanagerenable="$QueryModematAnalytics2"
	   uci set modem."${cellularwan2interface}".datatestenable="$DataTestEnable2"
	   uci set modem."${cellularwan2interface}".pingtestenable="$PingTestEnable2"
	   uci set modem."${cellularwan2interface}".pingip="$PingIp2"
	   uci set modem."${cellularwan2interface}".dataenable="$DataEnable2"
	   uci set modem."${cellularwan2interface}".service="$Sim2Service"
	   uci set modem."${cellularwan2interface}".apn="$Sim2Apn"
	   if [ "$Select" =  "failover" ]
       then
	   uci set modem."${cellularwan2interface}".metric="$Cwan2Priority"
	   else
	   uci set modem."${cellularwan2interface}".metric="1"
	   fi
	   uci set modem."${cellularwan2interface}".usbbuspath="$UsbBusPath2"
	   uci set modem."${cellularwan2interface}".action1waitinterval="$ActionInterval2"
	   uci set modem."${cellularwan2interface}".mtu="$mtu"
	   if [ "$CellularModem2" = "QuectelEC20" ] || [ "$CellularModem1" = "QuectelEC25E" ]
	   then
	   uci set modem."${cellularwan2interface}".protocol="$Protocol2EC20"
	   if [ "$Protocol2EC20" == "ppp" ]
	   then
		 uci set modem."${cellularwan2interface}".interfacename="3g-CWAN2"
	   else
		 uci set modem."${cellularwan2interface}".interfacename="wwan0"
	   fi
	   else
	   uci set modem."${cellularwan2interface}".protocol="$Protocol2"
	   if [ "$Protocol2" == "ppp" ]
	   then
		 uci set modem."${cellularwan2interface}".interfacename="3g-CWAN2"
	   else
		 uci set modem."${cellularwan2interface}".interfacename="usb0"
	   fi
	   fi
	   uci set modem."${cellularwan2interface}".smsresponsesenderenable="$SmsResponseSenderEnable1"
	   uci set modem."${cellularwan2interface}".smsresponseserverenable="$SmsResponseServerEnable1"
	   uci set modem."${cellularwan2interface}".smsservernumber1="$SmsServerNumber1"
	   uci set modem."${cellularwan2interface}".smsservernumber2="$SmsServerNumber2"
	   uci set modem."${cellularwan2interface}".smsservernumber3="$SmsServerNumber3"
	   uci set modem."${cellularwan2interface}".smsservernumber4="$SmsServerNumber4"
	   uci set modem."${cellularwan2interface}".smsservernumber5="$SmsServerNumber5"
	   
	   if [ "$Sim2Pdp" = "IPV4" ]
	   then
		   uci set modem."${cellularwan2interface}".ipv6="1"
	   fi      
	elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
	then
	   uci set modem.cellularmodule.singlesimsinglemodule="0"
	   uci set modem.cellularmodule.singlesimdualmodule="0"
	   uci set modem.cellularmodule.dualsimsinglemodule="1"
	   uci set modem."${cellularwan1interface}".modemenable="0"
	   uci set modem."${cellularwan1sim1interface}".modemenable="1"
	   uci set modem."${cellularwan1sim2interface}".modemenable="0"
	   uci set modem."${cellularwan1sim1interface}".actionmanagerenable="0"
	   uci set modem."${cellularwan1sim2interface}".actionmanagerenable="0"
	   uci set modem."${cellularwan2interface}".modemenable="0"
	   uci set modem."${cellularwan3interface}".modemenable="0"   
	   uci set modem."${cellularwan1sim1interface}".manufacturer="$Manufacturerlocal1"
	   uci set modem."${cellularwan1sim1interface}".model="$Model1"
	   uci set modem."${cellularwan1sim1interface}".porttype="$PortType1"
	   uci set modem."${cellularwan1sim1interface}".vendorid="$VendorId1"
	   uci set modem."${cellularwan1sim1interface}".productid="$ProductId1"
	   uci set modem."${cellularwan1sim1interface}".device="$DataPort1"
	   uci set modem."${cellularwan1sim1interface}".comport="$ComPort1"
	   uci set modem."${cellularwan1sim1interface}".smsport="$SmsPort1"
	   uci set modem."${cellularwan1sim1interface}".smsenable="$SmsEnable1"
	   uci set modem."${cellularwan1sim1interface}".smsc="$SmsCenterNumber1"
	   uci set modem."${cellularwan1sim1interface}".smsdeviceid="$DeviceId1"
	   uci set modem."${cellularwan1sim1interface}".smsapikey="$ApiKey1"
	   uci set modem."${cellularwan1sim1interface}".monitorenable="1"
	   uci set modem."${cellularwan1sim1interface}".analyticsmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1sim1interface}".statusmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1sim1interface}".datatestenable="$DataTestEnable1"
	   uci set modem."${cellularwan1sim1interface}".pingtestenable="$PingTestEnable1"
	   uci set modem."${cellularwan1sim1interface}".pingip="$PingIp1"
	   uci set modem."${cellularwan1sim1interface}".dataenable="$DataEnable1"
	   uci set modem."${cellularwan1sim1interface}".service="$Service1"
	   uci set modem."${cellularwan1sim1interface}".apn="$Apn1"
	   if [ "$Select" =  "failover" ]
       then
	   uci set modem."${cellularwan1sim1interface}".metric="$Cwan1sim1Priority"
	   else
	   uci set modem."${cellularwan1sim1interface}".metric="1"
	   fi
	   uci set modem."${cellularwan1sim1interface}".usbbuspath="$UsbBusPath1"
	   uci set modem."${cellularwan1sim1interface}".mtu="$mtu"
	   if [ "$CellularModem1" = "QuectelEC20" ] || [ "$CellularModem1" = "QuectelEC25E" ]
	   then
		   uci set modem."${cellularwan1sim1interface}".protocol="$Protocol1EC20"
		   if [ "$Protocol1EC20" == "ppp" ]
		   then
			 uci set modem."${cellularwan1sim1interface}".interfacename="3g-CWAN1_0"
		   else
			 uci set modem."${cellularwan1sim1interface}".interfacename="wwan0"
		   fi
	   else
		   uci set modem."${cellularwan1sim1interface}".protocol="$Protocol1"
		   if [ "$Protocol1" == "ppp" ]
		   then
			 uci set modem."${cellularwan1sim1interface}".interfacename="3g-CWAN1_0"
		   else
			 uci set modem."${cellularwan1sim1interface}".interfacename="usb0"
		   fi
	   fi
	   uci set modem."${cellularwan1sim1interface}".smsresponsesenderenable="$SmsResponseSenderEnable1"
	   uci set modem."${cellularwan1sim1interface}".smsresponseserverenable="$SmsResponseServerEnable1"
	   uci set modem."${cellularwan1sim1interface}".smsservernumber1="$SmsServerNumber1"
	   uci set modem."${cellularwan1sim1interface}".smsservernumber2="$SmsServerNumber2"
	   uci set modem."${cellularwan1sim1interface}".smsservernumber3="$SmsServerNumber3"
	   uci set modem."${cellularwan1sim1interface}".smsservernumber4="$SmsServerNumber4"
	   uci set modem."${cellularwan1sim1interface}".smsservernumber5="$SmsServerNumber5"
	   if [ "$Pdp1" = "IPV4" ]
	   then
		   uci set modem."${cellularwan1sim1interface}".ipv6="1"
	   fi          
	   uci set modem."${cellularwan1sim2interface}".manufacturer="$Manufacturerlocal1"
	   uci set modem."${cellularwan1sim2interface}".model="$Model1"
	   uci set modem."${cellularwan1sim2interface}".porttype="$PortType1"
	   uci set modem."${cellularwan1sim2interface}".vendorid="$VendorId1"
	   uci set modem."${cellularwan1sim2interface}".productid="$ProductId1"
	   uci set modem."${cellularwan1sim2interface}".device="$DataPort1"
	   uci set modem."${cellularwan1sim2interface}".comport="$ComPort1"
	   uci set modem."${cellularwan1sim2interface}".smsport="$SmsPort1"
	   uci set modem."${cellularwan1sim2interface}".smsenable="$SmsEnable1"
	   uci set modem."${cellularwan1sim2interface}".smsc="$SmsCenterNumber2"
	   uci set modem."${cellularwan1sim2interface}".smsdeviceid="$DeviceId1"
	   uci set modem."${cellularwan1sim2interface}".smsapikey="$ApiKey1"
	   uci set modem."${cellularwan1sim2interface}".monitorenable="1"
	   uci set modem."${cellularwan1sim2interface}".analyticsmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1sim2interface}".statusmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1sim2interface}".datatestenable="$DataTestEnable1"
	   uci set modem."${cellularwan1sim2interface}".pingtestenable="$PingTestEnable1"
	   uci set modem."${cellularwan1sim2interface}".pingip="$PingIp1"
	   uci set modem."${cellularwan1sim2interface}".dataenable="$DataEnable1"
	   uci set modem."${cellularwan1sim2interface}".service="$Sim2Service"
	   uci set modem."${cellularwan1sim2interface}".apn="$Sim2Apn"
	   if [ "$Select" =  "failover" ]
       then
	   uci set modem."${cellularwan1sim2interface}".metric="$Cwan1sim2Priority"
	   else
	   uci set modem."${cellularwan1sim2interface}".metric="1"
	   fi
	   uci set modem."${cellularwan1sim2interface}".usbbuspath="$UsbBusPath1"
	   uci set modem."${cellularwan1sim2interface}".mtu="$mtu"
	   if [ "$CellularModem1" = "QuectelEC20" ] || [ "$CellularModem1" = "QuectelEC25E" ]
	   then
		   uci set modem."${cellularwan1sim2interface}".protocol="$Protocol1EC20"
		   if [ "$Protocol1EC20" == "ppp" ]
		   then
			 uci set modem."${cellularwan1sim2interface}".interfacename="3g-CWAN1_1"
		   else
			 uci set modem."${cellularwan1sim2interface}".interfacename="wwan0"
		   fi
	   else
		   uci set modem."${cellularwan1sim2interface}".protocol="$Protocol1"
		   if [ "$Protocol1" == "ppp" ]
		   then
			 uci set modem."${cellularwan1sim2interface}".interfacename="3g-CWAN1_1"
		   else
			 uci set modem."${cellularwan1sim2interface}".interfacename="usb0"
		   fi
	   fi
	   uci set modem."${cellularwan1sim2interface}".smsresponsesenderenable="$SmsResponseSenderEnable1"
	   uci set modem."${cellularwan1sim2interface}".smsresponseserverenable="$SmsResponseServerEnable1"
	   uci set modem."${cellularwan1sim2interface}".smsservernumber1="$SmsServerNumber1"
	   uci set modem."${cellularwan1sim2interface}".smsservernumber2="$SmsServerNumber2"
	   uci set modem."${cellularwan1sim2interface}".smsservernumber3="$SmsServerNumber3"
	   uci set modem."${cellularwan1sim2interface}".smsservernumber4="$SmsServerNumber4"
	   uci set modem."${cellularwan1sim2interface}".smsservernumber5="$SmsServerNumber5"
	   if [ "$Pdp1" = "IPV4" ]
	   then
		   uci set modem."${cellularwan1sim2interface}".ipv6="1"
	   fi
	else
	   uci set modem.cellularmodule.singlesimsinglemodule="1"
	   uci set modem.cellularmodule.singlesimdualmodule="0"
	   uci set modem.cellularmodule.dualsimsinglemodule="0"
	   uci set modem."${cellularwan1interface}".modemenable="1"
	   uci set modem."${cellularwan1sim1interface}".modemenable="0"
	   uci set modem."${cellularwan1sim2interface}".modemenable="0"
	   uci set modem."${cellularwan2interface}".modemenable="0"
	   uci set modem."${cellularwan3interface}".modemenable="0"   
	   uci set modem."${cellularwan1interface}".manufacturer="$Manufacturerlocal1"
	   uci set modem."${cellularwan1interface}".model="$Model1"
	   uci set modem."${cellularwan1interface}".porttype="$PortType1"
	   uci set modem."${cellularwan1interface}".vendorid="$VendorId1"
	   uci set modem."${cellularwan1interface}".productid="$ProductId1"
	   uci set modem."${cellularwan1interface}".device="$DataPort1"
	   uci set modem."${cellularwan1interface}".comport="$ComPort1"
	   uci set modem."${cellularwan1interface}".smsport="$SmsPort1"
	   uci set modem."${cellularwan1interface}".smsenable="$SmsEnable1"
	   uci set modem."${cellularwan1interface}".smsc="$SmsCenterNumber1"
	   uci set modem."${cellularwan1interface}".smsdeviceid="$DeviceId1"
	   uci set modem."${cellularwan1interface}".smsapikey="$ApiKey1"
	   uci set modem."${cellularwan1interface}".monitorenable="1"
	   uci set modem."${cellularwan1interface}".actionmanagerenable="$MonitorEnable1"
	   uci set modem."${cellularwan1interface}".analyticsmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1interface}".statusmanagerenable="$QueryModematAnalytics1"
	   uci set modem."${cellularwan1interface}".datatestenable="$DataTestEnable1"
	   uci set modem."${cellularwan1interface}".pingtestenable="$PingTestEnable1"
	   uci set modem."${cellularwan1interface}".pingip="$PingIp1"
	   uci set modem."${cellularwan1interface}".dataenable="$DataEnable1"
	   uci set modem."${cellularwan1interface}".service="$Service1"
	   uci set modem."${cellularwan1interface}".apn="$Apn1"
	   uci set modem."${cellularwan1interface}".metric="$Cwan1Priority"
	   uci set modem."${cellularwan1interface}".usbbuspath="$UsbBusPath1"
	   uci set modem."${cellularwan1interface}".action1waitinterval="$ActionInterval1"
	   uci set modem."${cellularwan1interface}".mtu="$mtu"
	   if [ "$CellularModem1" = "QuectelEC20" ] || [ "$CellularModem1" = "QuectelEC25E" ]
	   then
		   uci set modem."${cellularwan1interface}".protocol="$Protocol1EC20"
		   if [ "$Protocol1EC20" == "ppp" ]
		   then
			 uci set modem."${cellularwan1interface}".interfacename="3g-CWAN1"
		   else
			 uci set modem."${cellularwan1interface}".interfacename="wwan0"
		   fi
	   else
		   uci set modem."${cellularwan1interface}".protocol="$Protocol1"
		   if [ "$Protocol1" == "ppp" ]
		   then
			 uci set modem."${cellularwan1interface}".interfacename="3g-CWAN1"
		   else
			 uci set modem."${cellularwan1interface}".interfacename="usb0"
		   fi
	   fi
	   uci set modem."${cellularwan1interface}".smsresponsesenderenable="$SmsResponseSenderEnable1"
	   uci set modem."${cellularwan1interface}".smsresponseserverenable="$SmsResponseServerEnable1"
	   uci set modem."${cellularwan1interface}".smsservernumber1="$SmsServerNumber1"
	   uci set modem."${cellularwan1interface}".smsservernumber2="$SmsServerNumber2"
	   uci set modem."${cellularwan1interface}".smsservernumber3="$SmsServerNumber3"
	   uci set modem."${cellularwan1interface}".smsservernumber4="$SmsServerNumber4"
	   uci set modem."${cellularwan1interface}".smsservernumber5="$SmsServerNumber5"
	   
	   if [ "$Pdp1" = "IPV4" ]
	   then
		   uci set modem."${cellularwan1interface}".ipv6="1"
	   fi
	fi
	uci commit modem
}

UpdateFirewallConfig()
{
	#~ if [ "$WifiDevicesDisabled" = "1" ]
	#~ then
	  #~ uci delete firewall.wifi_wan > /dev/null 2>&1
	  #~ uci delete firewall.wifi > /dev/null 2>&1
	#~ else
	InternetOverWifi="1"
	Radio0AccessPointEnable=$(uci get sysconfig.wificonfig.wifi1enable)
	
		uci delete firewall.wifi_wan > /dev/null 2>&1
		uci delete firewall.guestwifi > /dev/null 2>&1
		uci delete firewall.guestwificwan1_0 > /dev/null 2>&1
		uci delete firewall.guestwificwan1_1 > /dev/null 2>&1
		uci delete firewall.wifiwancwan1_1 > /dev/null 2>&1
		uci delete firewall.wifiwancwan1_0 > /dev/null 2>&1
		uci delete firewall.wifiwancwan1 > /dev/null 2>&1
		uci delete firewall.guestwificwan1 > /dev/null 2>&1
		uci delete firewall.guestwifiwan > /dev/null 2>&1
		
		if [ "$Wifi1Enable" = "0" ]
		then 
		   uci delete firewall.wifi_wan > /dev/null 2>&1
		   uci delete firewall.wifi > /dev/null 2>&1
		else
			if [ "$Wifi1Enable" = "1" ]
			then
			    if [ "$guestwifienable" = "1" ]
				then
					uci set firewall.guestwifi=zone
					uci set firewall.guestwifi.name="$wifiap1"
					uci set firewall.guestwifi.input="ACCEPT"
					uci set firewall.guestwifi.output="ACCEPT"
					uci set firewall.guestwifi.forward="REJECT"
					uci set firewall.guestwifi.network="$wifiap1"
					uci set firewall.guestwifi.masq="1"
					uci set firewall.guestwifi.mtu_fix="1"
					
					if [ "$EnableCellular" = "1" ]
					then
						if [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
						then
							uci set firewall.guestwificwan1_0=forwarding
							echo "$wifiap1"
							uci set firewall.guestwificwan1_0.src="$wifiap1"
							echo "$wifiap1"
							uci set firewall.guestwificwan1_0.dest="$cellularwan1sim1interface"
					
							uci set firewall.guestwificwan1_1=forwarding
							uci set firewall.guestwificwan1_1.src="$wifiap1"
							uci set firewall.guestwificwan1_1.dest="$cellularwan1sim2interface"
					
						elif [ "$CellularOperationModelocal" = "singlecellularsinglesim" ]
						then
							uci set firewall.guestwificwan1=forwarding
							uci set firewall.guestwificwan1.src="$wifiap1"
							uci set firewall.guestwificwan1.dest="$cellularwan1interface"
						fi
					fi
					
					if [ "$Wifi1Mode" = "sta" ] ||  [ "$Wifi1Mode" = "apsta" ]
					then
						 uci set firewall.guestwifiwan=forwarding
						 uci set firewall.guestwifiwan.src="$wifiap1"
						 uci set firewall.guestwifiwan.dest="$wifista"
					fi
			    else
			        uci delete firewall.guestwificwan1_0 > /dev/null 2>&1
					uci delete firewall.guestwificwan1_1 > /dev/null 2>&1
					uci delete firewall.guestwificwan1 > /dev/null 2>&1
					uci delete firewall.guestwifiwan > /dev/null 2>&1
				fi
				if [ "$Wifi1Mode" = "ap" ]
				then
					uci delete firewall.wifi_wan > /dev/null 2>&1
					uci set firewall.wifi=zone
					uci set firewall.wifi.name="$wifiap"
					uci set firewall.wifi.input="ACCEPT"
					uci set firewall.wifi.output="ACCEPT"
					uci set firewall.wifi.forward="REJECT"
					uci set firewall.wifi.network=ra0
					uci set firewall.wifi.masq="1"
					uci set firewall.wifi.mtu_fix="1"
					uci set firewall.wifi.extra_src="-m policy --dir in --pol none"
					uci set firewall.wifi.extra_dest="-m policy --dir out --pol none"
				else
					uci delete firewall.wifi > /dev/null 2>&1
					#uci delete firewall.wifiewan1 > /dev/null 2>&1
					#uci delete firewall.wifiewan2 > /dev/null 2>&1
					uci delete firewall.wificwan1 > /dev/null 2>&1
					uci delete firewall.wificwan2 > /dev/null 2>&1
					uci delete firewall.wificwan1_0 > /dev/null 2>&1
					uci delete firewall.wificwan1_1 > /dev/null 2>&1
					uci delete firewall.wifiwifiwan > /dev/null 2>&1
				fi 
				if [ "$Wifi1Mode" = "apsta" ]
				then
					uci delete firewall.wifi_wan > /dev/null 2>&1
					uci set firewall.wifi=zone
					uci set firewall.wifi.name="$wifiap"
					uci set firewall.wifi.input="ACCEPT"
					uci set firewall.wifi.output="ACCEPT"
					uci set firewall.wifi.forward="REJECT"
					uci set firewall.wifi.network=ra0
					uci set firewall.wifi.masq="1"
					uci set firewall.wifi.mtu_fix="1"
					uci set firewall.wifi.extra_src="-m policy --dir in --pol none"
					uci set firewall.wifi.extra_dest="-m policy --dir out --pol none"
					
					uci set firewall.wificwan1_0=forwarding
					uci set firewall.wificwan1_0.src="$wifiap"
					uci set firewall.wificwan1_0.dest="$cellularwan1sim1interface"
					
					uci set firewall.wificwan1_1=forwarding
					uci set firewall.wificwan1_1.src="$wifiap"
					uci set firewall.wificwan1_1.dest="$cellularwan1sim2interface"
				fi
				if [ "$Wifi1Mode" = "sta" ] ||  [ "$Wifi1Mode" = "apsta" ]
				then
					 #uci delete firewall.wifi > /dev/null 2>&1
					 uci set firewall.wifi_wan=zone
					 uci set firewall.wifi_wan.name="$wifista"
					 uci set firewall.wifi_wan.input="ACCEPT"
					 uci set firewall.wifi_wan.output="ACCEPT"
					 uci set firewall.wifi_wan.forward="REJECT"
					 uci set firewall.wifi_wan.network="$wifista"
					 uci set firewall.wifi_wan.masq="1"
					 uci set firewall.wifi_wan.mtu_fix="1"
					 uci set firewall.wifi_wan.extra_src="-m policy --dir in --pol none"
					 uci set firewall.wifi_wan.extra_dest="-m policy --dir out --pol none"
					
					 uci set firewall.wifiwifiwan=forwarding
					 uci set firewall.wifiwifiwan.src="$wifiap"
					 uci set firewall.wifiwifiwan.dest="$wifista"
						
					 else
					   uci delete firewall.wifi_wan > /dev/null 2>&1
					   uci delete firewall.wifiwifiwan > /dev/null 2>&1
			   
			fi
		fi
	fi
	
	if [ "$EnableCellular" = "1" ]
	then
		if [ "$CellularOperationModelocal" = "dualcellularsinglesim" ]
		then
		  uci delete firewall.cwan1_0 > /dev/null 2>&1
		  uci delete firewall.cwan1_1 > /dev/null 2>&1
		  uci delete firewall.wan6c1 > /dev/null 2>&1
		  uci delete firewall.wan6c2 > /dev/null 2>&1
		  uci set firewall.cwan1=zone
		  uci set firewall.cwan1.name="$cellularwan1interface"
		  uci set firewall.cwan1.input="ACCEPT"
		  uci set firewall.cwan1.output="ACCEPT"
		  uci set firewall.cwan1.forward="REJECT"
		  uci set firewall.cwan1.network="$cellularwan1interface wan6"
		  uci set firewall.cwan1.masq="1"
		  uci set firewall.cwan1.mtu_fix="1"
		  uci set firewall.cwan1.extra_src="-m policy --dir in --pol none"
		  uci set firewall.cwan1.extra_dest="-m policy --dir out --pol none"
		  uci set firewall.cwan2=zone
		  uci set firewall.cwan2.name="$cellularwan2interface"
		  uci set firewall.cwan2.input="ACCEPT"
		  uci set firewall.cwan2.output="ACCEPT"
		  uci set firewall.cwan2.forward="REJECT"
		  uci set firewall.cwan2.network="$cellularwan2interface wan6"
		  uci set firewall.cwan2.masq="1"
		  uci set firewall.cwan2.mtu_fix="1"
		  uci set firewall.cwan2.extra_src="-m policy --dir in --pol none"
		  uci set firewall.cwan2.extra_dest="-m policy --dir out --pol none"                                                    
		  uci delete firewall.wificwan1_0 > /dev/null 2>&1
		  uci delete firewall.wificwan1_1 > /dev/null 2>&1
		 
			if [ "$InternetOverWifi" = "1" ]
			then
			  if [ "$Radio0AccessPointEnable" = "1" ]
			  then
				uci set firewall.wificwan1=forwarding
				uci set firewall.wificwan1.src="$wifiap"
				uci set firewall.wificwan1.dest="$cellularwan1interface"
			  fi 
			  
			  if [ "$Wifi1Mode" = "sta" ]
			  then 
				uci set firewall.wifiwancwan1=forwarding
				uci set firewall.wifiwancwan1.src="$wifista"
				uci set firewall.wifiwancwan1.dest="$cellularwan1interface"
			 fi 
			fi
		elif [ "$CellularOperationModelocal" = "singlecellulardualsim" ]
		then
		   
		   uci delete firewall.cwan1 > /dev/null 2>&1
		   uci delete firewall.cwan2 > /dev/null 2>&1
		   uci delete firewall.udp_DHCPv6_replies
		   uci delete firewall.wan6c1 > /dev/null 2>&1
		   uci delete firewall.wan6c2 > /dev/null 2>&1
		   uci set firewall.cwan1_0=zone
		   uci set firewall.cwan1_0.name="$cellularwan1sim1interface"
		   uci set firewall.cwan1_0.input="ACCEPT"
		   uci set firewall.cwan1_0.output="ACCEPT"
		   uci set firewall.cwan1_0.forward="REJECT"
		   uci set firewall.cwan1_0.network="$cellularwan1sim1interface"
		   uci set firewall.cwan1_0.masq="1"
		   uci set firewall.cwan1_0.mtu_fix="1"
		   uci set firewall.cwan1_0.extra_src="-m policy --dir in --pol none"
		   uci set firewall.cwan1_0.extra_dest="-m policy --dir out --pol none"
		   uci set firewall.cwan1_1=zone
		   uci set firewall.cwan1_1.name="$cellularwan1sim2interface"
		   uci set firewall.cwan1_1.input="ACCEPT"
		   uci set firewall.cwan1_1.output="ACCEPT"
		   uci set firewall.cwan1_1.forward="REJECT"
		   uci set firewall.cwan1_1.network="$cellularwan1sim2interface"
		   uci set firewall.cwan1_1.masq="1"
		   uci set firewall.cwan1_1.mtu_fix="1"
		   uci set firewall.cwan1_1.extra_src="-m policy --dir in --pol none"
		   uci set firewall.cwan1_1.extra_dest="-m policy --dir out --pol none"  
		   
		   if [ "$PDP1" = "IPV6" ] || [ "$PDP1" = "IPV4V6" ] 
		   then
				uci set firewall.$cellularwan6sim1interface=zone
				uci set firewall.$cellularwan6sim1interface.name="$cellularwan6sim1interface"
				uci set firewall.$cellularwan6sim1interface.input="ACCEPT"
				uci set firewall.$cellularwan6sim1interface.output="ACCEPT"
				uci set firewall.$cellularwan6sim1interface.forward="REJECT"
				uci set firewall.$cellularwan6sim1interface.network="$cellularwan6sim1interface"
				uci set firewall.$cellularwan6sim1interface.masq="1"
				uci set firewall.$cellularwan6sim1interface.mtu_fix="1"
			
				uci set firewall.udp_DHCPwan6c1_replies=rule
				uci set firewall.udp_DHCPwan6c1_replies.target='ACCEPT'
				uci set firewall.udp_DHCPwan6c1_replies.src="$cellularwan6sim1interface"
				uci set firewall.udp_DHCPwan6c1_replies.proto='udp'
				uci set firewall.udp_DHCPwan6c1_replies.dest_port='546'
				uci set firewall.udp_DHCPwan6c1_replies.name='Allow DHCPwan6c1 replies'
				uci set firewall.udp_DHCPwan6c1_replies.family='ipv6'
				uci set firewall.udp_DHCPwan6c1_replies.src_port='547' 
		   fi        
		   if [ "$PDP2" = "IPV6" ] || [ "$PDP2" = "IPV4V6" ]
			 then
			    uci set firewall.$cellularwan6sim2interface=zone
				uci set firewall.$cellularwan6sim2interface.name="$cellularwan6sim2interface"
				uci set firewall.$cellularwan6sim2interface.input="ACCEPT"
				uci set firewall.$cellularwan6sim2interface.output="ACCEPT"
				uci set firewall.$cellularwan6sim2interface.forward="REJECT"
				uci set firewall.$cellularwan6sim2interface.network="$cellularwan6sim2interface"
				uci set firewall.$cellularwan6sim2interface.masq="1"
				uci set firewall.$cellularwan6sim2interface.mtu_fix="1"
			
				uci set firewall.udp_DHCPwan6c2_replies=rule
				uci set firewall.udp_DHCPwan6c2_replies.target='ACCEPT'
				uci set firewall.udp_DHCPwan6c2_replies.src="$cellularwan6sim2interface"
				uci set firewall.udp_DHCPwan6c2_replies.proto='udp'
				uci set firewall.udp_DHCPwan6c2_replies.dest_port='546'
				uci set firewall.udp_DHCPwan6c2_replies.name='Allow DHCPwan6c2 replies'
				uci set firewall.udp_DHCPwan6c2_replies.family='ipv6'
				uci set firewall.udp_DHCPwan6c2_replies.src_port='547'      
			fi
		   uci delete firewall.cwan1_1 > /dev/null 2>&1
		   uci delete firewall.wificwan1 > /dev/null 2>&1
		   uci delete firewall.wificwan2 > /dev/null 2>&1
		   uci delete firewall.wifiwancwan1 > /dev/null 2>&1
			  
			if [ "$InternetOverWifi" = "1" ]
			then
			       echo "InternetOverWifi=$InternetOverWifi"
			  if [ "$Radio0AccessPointEnable" = "1" ]
			  then
				uci set firewall.wificwan1_0=forwarding
				uci set firewall.wificwan1_0.src="$wifiap"
				uci set firewall.wificwan1_0.dest="$cellularwan1sim1interface"
			  fi
			   
			  if [ "$Wifi1Mode" = "sta" ]
			  then
					uci set firewall.wifiwancwan1_0=forwarding
					uci set firewall.wifiwancwan1_0.src="$wifista"
					uci set firewall.wifiwancwan1_0.dest="$cellularwan1sim1interface"
			  fi    
		  fi 
		   
			if [ "$InternetOverWifi" = "1" ]
			then
			  if [ "$Radio0AccessPointEnable" = "1" ]
			  then
				uci set firewall.wificwan1_1=forwarding
				uci set firewall.wificwan1_1.src="$wifiap"
				uci set firewall.wificwan1_1.dest="$cellularwan1sim2interface"
			  fi 
			  if [ "$Wifi1Mode" = "sta" ]
			  then
					uci set firewall.wifiwancwan1_1=forwarding
					uci set firewall.wifiwancwan1_1.src="$wifista"
					uci set firewall.wifiwancwan1_1.dest="$cellularwan1sim1interface"
			  fi    
		    fi 
	     	else
		   uci delete firewall.cwan1_0 > /dev/null 2>&1
		   uci delete firewall.cwan1_1 > /dev/null 2>&1
		   uci delete firewall.wan6c1 > /dev/null 2>&1
		   uci delete firewall.wan6c2 > /dev/null 2>&1
		   uci delete firewall.cwan2 > /dev/null 2>&1
		   uci delete firewall.udp_DHCPv6_replies
		   uci set firewall.cwan1=zone
		   uci set firewall.cwan1.name="$cellularwan1interface"
		   uci set firewall.cwan1.input="ACCEPT"
		   uci set firewall.cwan1.output="ACCEPT"
		   uci set firewall.cwan1.forward="REJECT"
		   uci set firewall.cwan1.network="$cellularwan1interface"
		   uci set firewall.cwan1.masq="1"
		   uci set firewall.cwan1.mtu_fix="1"
		   uci set firewall.cwan1.extra_src="-m policy --dir in --pol none"
		   uci set firewall.cwan1.extra_dest="-m policy --dir out --pol none"
		   
		   if [ "$PDP1" = "IPV6" ] || [ "$PDP1" = "IPV4V6" ] || [ "$PDP2" = "IPV6" ] || [ "$PDP2" = "IPV4V6" ]
		   then
				uci set firewall.udp_DHCPv6_replies=rule
				uci set firewall.udp_DHCPv6_replies.target='ACCEPT'
				uci set firewall.udp_DHCPv6_replies.src='wan6c1'
				uci set firewall.udp_DHCPv6_replies.proto='udp'
				uci set firewall.udp_DHCPv6_replies.dest_port='546'
				uci set firewall.udp_DHCPv6_replies.name='Allow DHCPv6 replies'
				uci set firewall.udp_DHCPv6_replies.family='ipv6'
				uci set firewall.udp_DHCPv6_replies.src_port='547'   
				
				uci set firewall.$cellularwan6sim1interface=zone
				uci set firewall.$cellularwan6sim1interface.name="$cellularwan6sim1interface"
				uci set firewall.$cellularwan6sim1interface.input="ACCEPT"
				uci set firewall.$cellularwan6sim1interface.output="ACCEPT"
				uci set firewall.$cellularwan6sim1interface.forward="REJECT"
				uci set firewall.$cellularwan6sim1interface.network="$cellularwan6sim1interface"
				uci set firewall.$cellularwan6sim1interface.masq="1"
				uci set firewall.$cellularwan6sim1interface.mtu_fix="1"		
				      
		   fi
		   
		  
		   uci delete firewall.wificwan1_0 > /dev/null 2>&1
		   uci delete firewall.wificwan1_1 > /dev/null 2>&1
		   uci delete firewall.wificwan2 > /dev/null 2>&1
		  
			if [ "$InternetOverWifi" = "1" ]
			then
			  if [ "$Radio0AccessPointEnable" = "1" ]
			  then
				uci set firewall.wificwan1=forwarding
				uci set firewall.wificwan1.src="$wifiap"
				uci set firewall.wificwan1.dest="$cellularwan1interface"
			  fi 
		   fi 
		fi
	  else
		  uci delete firewall.cwan1 > /dev/null 2>&1
		  uci delete firewall.cwan2 > /dev/null 2>&1
		  uci delete firewall.cwan1_0 > /dev/null 2>&1
		  uci delete firewall.cwan1_1 > /dev/null 2>&1
		  uci delete firewall.wificwan1 > /dev/null 2>&1
		  uci delete firewall.wificwan2 > /dev/null 2>&1
		  uci delete firewall.wificwan1_0 > /dev/null 2>&1
		  uci delete firewall.wificwan1_1 > /dev/null 2>&1
	fi
	
  
   if [ "$InternetOverWifi" = "0" ]
   then
	   uci delete firewall.wifiewan1 > /dev/null 2>&1
	   uci delete firewall.wificwan1 > /dev/null 2>&1
	   uci delete firewall.wificwan1_0 > /dev/null 2>&1
	   uci delete firewall.wificwan1_1 > /dev/null 2>&1
	   uci delete firewall.wificwan2 > /dev/null 2>&1
	   uci delete firewall.wifiwifiwan > /dev/null 2>&1
	   uci delete firewall.wifiwancwan1 > /dev/null 2>&1
	   uci delete firewall.wifiwancwan1_0 > /dev/null 2>&1
	   uci delete firewall.wifiwancwan1_1 > /dev/null 2>&1
   fi
   if [ "$Radio0AccessPointEnable" = "0" ]
   then
	   uci delete firewall.wificwan1 > /dev/null 2>&1
	   uci delete firewall.wificwan1_0 > /dev/null 2>&1
	   uci delete firewall.wificwan1_1 > /dev/null 2>&1
	   uci delete firewall.wificwan2 > /dev/null 2>&1
	   uci delete firewall.wifiwifiwan > /dev/null 2>&1
   fi
	uci commit firewall
}

SystemConfigFile="/etc/config/sysconfig"
FailoverConfigFile="/etc/config/mwan3config"
LoadBalancingConfigFile="/etc/config/loadbalancingconfig"
simtmpfile="/tmp/simnumfile"
wirelessdatfile="/etc/wireless/mt7628/mt7628.dat"

/etc/init.d/mwan3 stop 2>&1


UpdateRelayServer
ReadSystemConfigFile
ReadMwanConfigFile_Failover
ReadMwanConfigFile_LoadBalancing
UpdateNetworkConfig
UpdateWirelessConfig
UpdateNetworkConfig
#UpdateMwanConfig
UpdateScheduledWifiOnOff

if [ "$EnableCellular" = "1" ]
then
/etc/init.d/smstools3 stop
UpdateModemConfig
/etc/init.d/smstools3 start
else
   uci set modem."${cellularwan1interface}".modemenable="0"
   uci set modem."${cellularwan1sim1interface}".modemenable="0"
   uci set modem."${cellularwan1sim2interface}".modemenable="0"
   uci set modem."${cellularwan2interface}".modemenable="0"
   uci set modem."${cellularwan3interface}".modemenable="0"
fi
UpdateFirewallConfig

/root/InterfaceManager/script/SystemRestart.sh > /dev/null 2>&1 & 

exit 0
#~ #/bin/sleep 10

#~ /etc/init.d/network restart 2>&1

#~ /bin/sleep 40


#/root/InterfaceManager/script/InterfaceInitializer.sh boot

#~ /etc/init.d/firewall restart 2>&1 
#~ /etc/init.d/mwan3 start 2>&1
