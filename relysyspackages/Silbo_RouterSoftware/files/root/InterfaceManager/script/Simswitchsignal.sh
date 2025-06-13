#!/bin/sh

. /lib/functions.sh 

#getting RSRP ans SINR values from Update_Analytics_data.sh script and storing it in Sig.txt file
echo  "$1 $2" >>  /tmp/Sig.txt

num_intervals=5

rsrp_total=0
sinr_total=0
rsrp_count=0
sinr_count=0

#threshold_rsrp=-100
#threshold_sinr=15

line=$(wc -l < /tmp/Sig.txt)

if [ $line -gt $((num_intervals-1)) ]
then 
	 for i in $(seq 1 $num_intervals)
	do 
		rsrp=$(cat /tmp/Sig.txt | head -$i | tail -1 | cut -d " " -f 1)
		sinr=$(cat /tmp/Sig.txt | head -$i | tail -1 | cut -d " " -f 2)
		
		rsrp_total=$(expr $rsrp_total + $rsrp) 
		sinr_total=$(expr $sinr_total + $sinr)   
   
	done
	
rsrp_avg=$(expr $rsrp_total / $num_intervals) 
sinr_avg=$(expr $sinr_total / $num_intervals)

 threshold_rsrp=$(uci get simswitchconfig.simswitchconfig.threshrsrp)
 threshold_sinr=$(uci get simswitchconfig.simswitchconfig.threshsinr)

if [[ "$rsrp_avg" -lt "$threshold_rsrp" ]] &&  [[ "$sinr_avg" -lt "$threshold_sinr" ]]
then
 # ifconfig usb0 down
 # ifconfig wwan0 down
simnum=$(cat /tmp/simnumfile)
 if [ "$simnum" = "1" ];then
 /root/InterfaceManager/script/SimSwitch.sh CWAN1 2
else
 /root/InterfaceManager/script/SimSwitch.sh CWAN1 1
fi
  rm -rf /tmp/Sig.txt
fi

echo "$(cat /tmp/Sig.txt | tail -$(($num_intervals-1)))" > /tmp/Sig.txt

fi


