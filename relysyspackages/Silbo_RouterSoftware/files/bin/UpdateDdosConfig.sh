#!/bin/sh
. /lib/functions.sh


#DdosConfigFile="/etc/config/firewall"
#DdosConfigSection="firewall"

#ReadDdosConfigFile()
#{
        #config_load "$DdosConfigFile"
        #config_foreach UpdateDdosConfig rule
        #config_get Enabled rule enabled
#}


#UpdateDdosConfig()
#{
    #NoOfSectionCount=$((NoOfSectionCount + 1))
	
     #enabled=$(uci get firewall.@rule[$NoOfSectionCount].enabled)
	#if [ "$enabled" = "1" ]
	 #then           
	#uci set firewall.@rule[$NoOfSectionCount].limit
    #uci set firewall.@rule[$NoOfSectionCount].limit_burst
    #else
       #uci delete firewall.@rule[$NoOfSectionCount].enabled 
     	#uci delete firewall.@rule[$NoOfSectionCount].limit
    #uci delete firewall.@rule[$NoOfSectionCount].limit_burst    
     #fi
    #uci commit firewall
    
#}

RestartInitScript()
{
	/etc/init.d/firewall restart
	sleep 1
	# mwan3 should restart after the firewall gets updated 
	# why because while updating the firewall config, mwan3 will try to ping 
	# mwan3 will go to hung state 
	/etc/init.d/mwan3 restart 
}


#ReadDdosConfigFile
#UpdateDdosConfig

RestartInitScript
 
 
exit 0
