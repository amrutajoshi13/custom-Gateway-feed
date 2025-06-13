#!/bin/sh

. /lib/functions.sh

LogAvgLog="/root/LoadAvgLog.txt"
LogrotateConfigFile=/etc/logrotate.d/watchdogLogrotateConfig

# Read configuration values
MEMORY_THRESHOLD=$(uci get watchdogconfigsw.watchdogconfigsw.memory)
WATCHDOG_TIME=$(uci get watchdogconfigsw.watchdogconfigsw.time)
MAX_LOAD=$(uci get watchdogconfigsw.watchdogconfigsw.load)



# Function to check internet connectivity
check_load() {
        Output=$(uptime 2>&1)
        Load1=$(echo "$Output" | awk -F 'load average: ' '{print $2}' | awk -F ', ' '{print $1}')
        integer_number=$(echo $Load1 | cut -d '.' -f 1)
           
        echo "$integer_number"
                if [ "$integer_number" -ge "$MAX_LOAD" ]; then
                        free_output=$(free -h)
                        echo "[$(date +"%Y-%m-%d %H:%M:%S")]" >> "$LogAvgLog"
                        {
						    echo "##################################################"
						    echo "FREE COMMAND OUTPUT:"
						    echo "$free_output"
						} >> "$LogAvgLog"


                        echo "##################################################" >> "$LogAvgLog"
                        printf "LoadAvg=%s\n" "$integer_number" >> "$LogAvgLog"
                        echo "device rebooted" >> "$LogAvgLog"
                        echo "************************************************************" >> "$LogAvgLog"

                        return 1
                else
                        return 0
                fi
                
                logrotate "$LogrotateConfigFile"
}

			get_available_memory()
			{
			  free -k | awk '/^Mem:/ {print $7}'
			}
			
	
			check_memory() {
			  local available_memory=$(get_available_memory)
			  echo "Available Memory: $available_memory KB"
			  
			  if [ "$available_memory" -lt "$MEMORY_THRESHOLD" ]; then
			    free_output=$(free -k)
                        echo "[$(date +"%Y-%m-%d %H:%M:%S")]" >> "$LogAvgLog"
                        {
						    echo "FREE COMMAND OUTPUT:"
						    echo "$free_output"
						} >> "$LogAvgLog"


                        echo "##################################################" >> "$LogAvgLog"
                        printf "Memusage=%d\n" "$available_memory" >> "$LogAvgLog"
                        echo "device rebooted" >> "$LogAvgLog"
                        echo "************************************************************" >> "$LogAvgLog"
			 #   /root/usrRPC/script/Board_Recycle_12V_Script.sh
				 return 1
              else
                 return 0
              fi
                
                logrotate "$LogrotateConfigFile"
			  
			}
			check_memory

while true; do
    /sbin/watchdog -t "$WATCHDOG_TIME" /dev/watchdog

    if check_load; then
        if check_memory; then
            sleep "$WATCHDOG_TIME"
        else
            # Stop feeding the watchdog and run the reboot script
            /sbin/watchdog -t 0 /dev/watchdog
            /root/usrRPC/script/Board_Recycle_12V_Script.sh
        fi
    else
        # Stop feeding the watchdog and run RestoreDataCollector script
        /sbin/watchdog -t 0 /dev/watchdog
        sh -x /bin/RestoreDataCollector.sh

       
    fi
done



 
