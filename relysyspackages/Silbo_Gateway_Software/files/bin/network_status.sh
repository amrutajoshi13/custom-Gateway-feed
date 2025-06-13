#!/bin/sh

LOG_FILE="/root/networkstatuslogs.txt"
LogrotateConfigFile="/etc/logrotate.d/networstatuslogrotate"
file1="/tmp/InterfaceStatus/CWAN1_0Status"
file2="/tmp/InterfaceStatus/EWAN5Status"
file3="/tmp/InterfaceStatus/CWAN1_1Status"
file4="/tmp/InterfaceStatus/WIFI_WANStatus"
file5="/tmp/InterfaceStatus/CWAN1Status"

last_line1=$(tail -1 "$file1")
last_line2=$(tail -1 "$file2")
last_line3=$(tail -1 "$file3")
last_line4=$(tail -1 "$file4")
last_line5=$(tail -1 "$file5")

last_field1=$(echo "$last_line1" | awk '{print $NF}')
last_field2=$(echo "$last_line2" | awk '{print $NF}')
last_field3=$(echo "$last_line3" | awk '{print $NF}')
last_field4=$(echo "$last_line4" | awk '{print $NF}')
last_field5=$(echo "$last_line5" | awk '{print $NF}')

time_stamp=$(date)

if [[ "$last_field1" == "UP" ]] || [[ "$last_field2" == "UP" ]] || [[ "$last_field3" == "UP" ]] || [[ "$last_field4" == "UP" ]] || [[ "$last_field5" == "UP" ]]; then

	echo "1" > /tmp/networkstatus
	echo "[$time_stamp] networkstatus is 1" >> "$LOG_FILE"
else
	echo "0" > /tmp/networkstatus
	echo "[$time_stamp] networkstatus is 0" >> "$LOG_FILE"
fi


logrotate "$LogrotateConfigFile"
exit 0
