#!/bin/sh

i=0

for i in 1 2 3
do
 Ifconfig_Result=$(ifconfig)
 if [ -z "${Ifconfig_Result}" ]
 then
  if [ "$i" = "3" ]
  then
    /root/usrRPC/script/Board_Recycle_12V_Script.sh
  fi 
  /bin/sleep 180 
 else
  break
 fi
done
