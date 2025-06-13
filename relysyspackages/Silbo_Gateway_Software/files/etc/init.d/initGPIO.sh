#!/bin/sh /etc/rc.common
. /lib/functions.sh

START=98
STOP=98
USE_PROCD=1

		
DIOConfig()
{
	numberOfDidoGpio=$(uci get digitalinputconfig.didogpioconfig.numberOfDido)
	board_name=$(cat /tmp/sysinfo/board_name)
        file_content=$(cat /root/ReadDIAppComponent/etc/Config/DIOStatus.txt)	
	for i in $(seq 1 $numberOfDidoGpio)
    do
		#gpio pins for i'th di and do
		DIOMode=$(uci get digitalinputconfig.digitalinputconfig.DIOMode${i})
		
		di=$(uci get digitalinputconfig.didogpioconfig.di${i})
		do=$(uci get digitalinputconfig.didogpioconfig.do${i})

                eval divalue=$(echo $file_content | awk -F ',' -v field=$i '{print $field}')
                echo "divalue=$divalue"
			
		#export i'th di pin
		echo "$di" > /sys/class/gpio/export
			
		#exporting i'th do pin
		
		if [ "$DIOMode" = "1" ]
		then
		    echo "$do" > /sys/class/gpio/export
			echo "out" > /sys/class/gpio/gpio${do}/direction
            echo "$divalue" > /sys/class/gpio/gpio${do}/value
			if echo "$board_name" | grep -qE "(IAB44)";
			then
				external_controller_gpio=$((489+$i))
				echo "1" > /sys/class/gpio/gpio${external_controller_gpio}/value
			fi
			
			if echo "$board_name" | grep -qE "(IAC44)";
			then
				if [ $i -eq 1 ]
				then
					external_controller_gpio=$((487+$i))
					echo "1" > /sys/class/gpio/gpio${external_controller_gpio}/value
				fi
    		fi
		fi
	done

}

AIOConfig()
{
	numberOfAiGpio=$(uci get analoginputconfig.aigpio.numberOfAiGpio)
	
	for i in $(seq 1 $numberOfAiGpio)
	do
		ai=$(uci get analoginputconfig.aigpio.ai${i})
		
        echo "$ai" > /sys/class/gpio/export         
        echo "out" > /sys/class/gpio/gpio${ai}/direction
        echo "1" > /sys/class/gpio/gpio${ai}/value
    done    
}

start_service() 
{
	 DIOConfig
	 AIOConfig  
  }
     
Action=$1
case "$Action" in
    start)
        echo "Starting Apps"
        start_service
        ;;

    cron_start)
        RunMonit
        ;;
    
     stop)
        stop_service
        ;;
    *)
        echo "Usage: $0 {start|cron_start|stop}"
        ;;
esac     
