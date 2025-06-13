#!/bin/sh
. /lib/functions.sh
board_name=$(cat /tmp/sysinfo/board_name)

if echo "$board_name" | grep -qE "(IAB)";
then
	 cp /Web_Page_Gateway_Apps/IAB44_GW/etc/snmp/* /etc/snmp
elif echo "$board_name" | grep -qE "(IAC)";
then 
	cp /Web_Page_Gateway_Apps/IAC44_GW/etc/snmp/* /etc/snmp
elif echo "$board_name" | grep -qE "(IAF-C_GW)";
then 
	cp /Web_Page_Gateway_Apps/IAF44_GW/IAF44-C/etc/snmp/* /etc/snmp
elif echo "$board_name" | grep -qE "(IAF-C1_GW)";
then  
	cp /Web_Page_Gateway_Apps/IAF44_GW/IAF44-C/etc/snmp/* /etc/snmp
fi

echo "0 */6 * * * sh -x /bin/TCP_Monit.sh" >> /etc/crontabs/root
uci set boardconfig.board.TCPSlaveApplicationSwVer="1.01"
uci commit boardconfig
/etc/init.d/tcpslave start
