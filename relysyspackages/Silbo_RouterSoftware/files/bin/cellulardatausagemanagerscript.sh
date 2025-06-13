#!/bin/sh
. /lib/functions.sh

sysconfigUCIPath=/etc/config/sysconfig
sysconfigsection="sysconfig"

simswitchconfigUCIPath=/etc/config/simswitchconfig
simswitchconfigsection="simswitchconfig"

cellulardatausagemanagercronscript="/bin/cellulardatausagemanagercronscript.sh"

config_load "$sysconfigUCIPath"
config_get CellularOperationMode "$sysconfigsection" CellularOperationMode 
config_get enablecellular sysconfig enablecellular

config_load "$simswitchconfigUCIPath"
config_get Simswitchbasedon "$simswitchconfigsection" simswitch
#config_get cellulardataswitchlimitenable "$simswitchconfigsection" cellulardataswitchlimitenable 
config_get cellulardatausagemanagerperiodicity "$simswitchconfigsection" cellulardatausagemanagerperiodicity
config_get cellulardataswitchonspeedenable "$simswitchconfigsection" cellulardataswitchonspeedenable
config_get dayofmonth "$simswitchconfigsection" dayofmonth
config_get periodicspeedtestinterval "$simswitchconfigsection" periodicspeedtestinterval


curTme=$(date "+%H:%M:%S")
echo "$curTme"
PeriodicTme=$(date -d@"$(( `date +%s`+$periodicspeedtestinterval*3600))" +%H:%M:%S)
echo "$PeriodicTme"
Hrs=$(echo "$PeriodicTme" | awk -F':' '{ printf("%d\n", $1); }')
Mns=$(echo "$PeriodicTme" | awk -F':' '{ printf("%d\n", $2); }')
printf "$Hrs\n"
printf "$Mns\n"


if [ "$enablecellular" = "1" ]
then
	 if [ "$CellularOperationMode" = "singlecellulardualsim" ]
	 then
	 
		  if [ "$Simswitchbasedon" = "datalim" ]
		  then
				if [ "$cellulardatausagemanagerperiodicity" = "daily" ]
				then      
					  # add entry to cron file
					sed -i '/Reset_data_usage.sh/d' /etc/crontabs/root
					echo "2 0 * * * /root/InterfaceManager/script/Reset_data_usage.sh" >> /etc/crontabs/root
					#Add datacap script cronjob here instead of $cellulardatausagemanagercronscript
					sed -i '/Data_Cap/d' /etc/crontabs/root
					echo "*/2 * * * * /root/InterfaceManager/script/Data_Cap.sh" >> /etc/crontabs/root
					#$cellulardatausagemanagercronscript
			   fi
			   
			   if [ "$cellulardatausagemanagerperiodicity" = "monthly" ]
				then      
					  # add entry to cron file
					sed -i '/Reset_data_usage.sh/d' /etc/crontabs/root
					echo "2 0 $dayofmonth * * /root/InterfaceManager/script/Reset_data_usage.sh" >> /etc/crontabs/root
					 #Add datacap script cronjob here instead of $cellulardatausagemanagercronscript
						sed -i '/Data_Cap/d' /etc/crontabs/root
						echo "*/2 * * * * /root/InterfaceManager/script/Data_Cap.sh" >> /etc/crontabs/root
					#$cellulardatausagemanagercronscript
			   fi
			else
	            sed -i '/Reset_data_usage/d' /etc/crontabs/root
                sed -i '/Data_Cap/d' /etc/crontabs/root  
		    fi  
	 	 
	  else
	     sed -i '/Reset_data_usage/d' /etc/crontabs/root
         sed -i '/cellulardatausagemanagerspeedcronscript/d' /etc/crontabs/root
         
        
         sed -i '/Data_Cap/d' /etc/crontabs/root  
	  fi 
	   
	  if [ "$CellularOperationMode" = "singlecellulardualsim" ]
	  then
	 
		  if [ "$cellulardataswitchonspeedenable" = "1" ]
		  then
		  
			# add entry to cron file
					sed -i '/cellulardatausagemanagerspeedcronscript/d' /etc/crontabs/root
					#echo "0 */$periodicspeedtestinterval * * * /root/InterfaceManager/script/cellulardatausagemanagerspeedcronscript.sh" >> /etc/crontabs/root
					echo "$Mns $Hrs * * * /root/InterfaceManager/script/cellulardatausagemanagerspeedcronscript.sh" >> /etc/crontabs/root
		  else
               sed -i '/cellulardatausagemanagerspeedcronscript/d' /etc/crontabs/root
		  fi
	  else
	     sed -i '/Reset_data_usage/d' /etc/crontabs/root
         sed -i '/cellulardatausagemanagerspeedcronscript/d' /etc/crontabs/root
         sed -i '/Data_Cap/d' /etc/crontabs/root  
	  fi	 

	 /etc/init.d/cron restart
		sleep 2  

else
   sed -i '/Reset_data_usage/d' /etc/crontabs/root
   sed -i '/cellulardatausagemanagerspeedcronscript/d' /etc/crontabs/root
   sed -i '/Data_Cap/d' /etc/crontabs/root
fi
exit 0


