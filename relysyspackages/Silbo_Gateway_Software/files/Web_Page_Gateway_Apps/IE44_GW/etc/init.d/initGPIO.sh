#!/bin/sh /etc/rc.common
. /lib/functions.sh

START=98
STOP=98
USE_PROCD=1

		
DIOConfig()
{
	numberOfDidoGpio=$(uci get digitalinputconfig.didogpioconfig.numberOfDido)
	board_name=$(cat /tmp/sysinfo/board_name)
	  
	
		for i in $(seq 1 $numberOfDidoGpio)
	    do
			#gpio pins for i'th di and do
			DIOMode=$(uci get digitalinputconfig.digitalinputconfig.DIOMode${i})
			
			di=$(uci get digitalinputconfig.didogpioconfig.di${i})
			do=$(uci get digitalinputconfig.didogpioconfig.do${i})
				
			#export i'th di pin
			if [ ! -d "/sys/class/gpio/gpio${di}" ]
            then 
				 echo "$di" > /sys/class/gpio/export
		    fi	
			 if echo "$board_name" | grep -qE "(IE44)";
			 then
				      dioselect=$(uci get digitalinputconfig.didogpioconfig.dioselect${i})
				      if [ "$DIOMode" = "0" ]
					  then
						  if [ ! -d "/sys/class/gpio/gpio${dioselect}" ]
				          then
							   echo "$dioselect" > /sys/class/gpio/export
							   echo "out" > /sys/class/gpio/gpio${dioselect}/direction
							   echo "0" > /sys/class/gpio/gpio${dioselect}/value
						  fi
					  else if [ "$DIOMode" = "1" ]
					  then
						  if [ ! -d "/sys/class/gpio/gpio${dioselect}" ]
				          then
						       echo "$dioselect" > /sys/class/gpio/export
							   echo "out" > /sys/class/gpio/gpio${dioselect}/direction
							   echo "1" > /sys/class/gpio/gpio${dioselect}/value
						  fi
					  fi	
			       
			 fi	
					
					if [ "$DIOMode" = "1" ]
					then
						    if [ ! -d "/sys/class/gpio/gpio${dioselect}" ]
				            then
							    echo "$do" > /sys/class/gpio/export
						    fi
     						echo "out" > /sys/class/gpio/gpio${do}/direction
							if echo "$board_name" | grep -qE "(IAB44)";
							then
								external_controller_gpio=$((489+$i))
								echo "1" > /sys/class/gpio/gpio${external_controller_gpio}/value
							fi
							
							if echo "$board_name" | grep -qE "(IDBXX)";
							then
								external_controller_gpio=$((391+$i))
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
				     else
				    		echo "in" > /sys/class/gpio/gpio${di}/direction		   		
			    		
				    fi
			fi # End of if condition of IE
			
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
	board_name=$(cat /tmp/sysinfo/board_name)
	DIOConfig
	if [ "$board_name" != "Silbo_IE44-B_GW" ] && [ "$board_name" != "Silbo_IE44-C_GW" ]
    then
		 AIOConfig  
    fi		 
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
