#!/bin/sh

. /lib/functions.sh

sessionlist=$(ubus call session list | grep -i "ubus_rpc_session" | cut -d " " -f2 | tail -n 1 | tr -d "," | tr -d "'")
echo sessionlist=$sessionlist
logout(){
output=$(curl -d '{ "jsonrpc": "2.0", "id": 1, "method": "call", "params": [ '$sessionlist', "session", "destroy", {} ] }'  http://$href/ubus)
echo "$output" > /tmp/logoutresult.txt

finalout=$(cat /tmp/logoutresult.txt | cut -d "," -f3 | cut -d ":" -f1)
echo "$finalout"

    echo "Success : Log out"
    echo "http://$href/" > /tmp/logoutresult.txt   
 
exit 0
}  

for i in $(seq 1 ${lanCount})
do
	lanCount=$(cat /etc/internetoverlan.txt | wc -l)
	lan=$(cat /etc/internetoverlan.txt | head -${i} | tail -1)
	staticipaddr=$(uci get networkinterfaces.${lan}.staticIP)
	href=$staticipaddr
	if [ -n "$href" ]
	then
		logout	
	else
		echo  1 > /tmp/logoutresult.txt

	fi
done	


