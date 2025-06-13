#!/bin/sh

. /lib/functions.sh

SourceConfigPath="/root/SourceAppComponent/etc/Config/DataSourcesConfig"
board_name=$(cat /tmp/sysinfo/board_name)
EMeterRS232Line1DataSourceEnable=$(uci get sourceconfig.sourceconfig.EMeterRS232Line1DataSourceEnable)     


detect_rs232_ports() {
    echo "Detecting RS232 USB devices from dmesg..."
    usb_ports=""

if echo "$board_name" | grep -qE "(IAF44-C_GW)";
then
     for port in $(dmesg | grep USB | grep ch34 | grep -o 'ttyUSB[0-9]\+'); do
        port_num=$(echo "$port" | grep -o '[0-9]\+')

        echo "Checking RS232 port: /dev/$port"
        usb_ports="$usb_ports /dev/$port"
    done
 else
 
	 for port in $(dmesg | grep USB | grep cp210  | grep -o 'ttyUSB[0-9]\+'); do
        port_num=$(echo "$port" | grep -o '[0-9]\+')

        echo "Checking RS232 port: /dev/$port"
        usb_ports="$usb_ports /dev/$port"
    done   
    
fi
    if [ -z "$usb_ports" ]; then
        echo "... No RS232 USB serial ports found!"
        exit 1
    fi

    echo "Detected RS232 ports for verification: $usb_ports"
}

confirm_rs232_port() 
{
    # Extract the first port from the detected list
    SerialPort2=$(echo "$usb_ports" | awk '{print $1}')

    if [ -n "$SerialPort2" ]; then
        echo "RS232 Port: $SerialPort2"
        return 0
    else
        echo "port not found."
        return 1
    fi
}

if echo "$board_name" | grep -qE "(GD44-C|GD44-D|IAB44-B|IAB44-C|IAF44-C_GW)";
then
	productid=$(cat /sys/devices/platform/101c0000.ehci/usb1/1-1/1-1.1/idProduct)
	vendorid=$(cat /sys/devices/platform/101c0000.ehci/usb1/1-1/1-1.1/idVendor)
else
	productid=$(cat /sys/devices/platform/101c0000.ehci/usb1/1-1/idProduct)
	vendorid=$(cat /sys/devices/platform/101c0000.ehci/usb1/1-1/idVendor)
fi
if echo "$board_name" | grep -qE "(GRD44C)";                                                                     
then 
	uci set RS232UtilityConfigGeneric.rs232utilityconfig.SerialPort="/dev/ttyS0"

elif echo "$board_name" | grep -qE "(IAB44-B|IAB44-C|IAF44-C_GW)";                                                                     
        then 
            path=$(echo /sys/devices/platform/101c0000.ehci/usb1/1-1/1-1.2/1-1.2\:1.0 | cut -d '/' -f 9 | cut -d ':' -f 2)
		    if [ "$path" = "1.0" ]
			then
	               if [ -z "$vendorid" ] && [ -z "$productid" ]
				   then
						if echo "$board_name" | grep -qE "(IAB44-B|IAB44-C)";                                                                     
						then
							  uci set RS232UtilityConfigGeneric.rs232utilityconfig.SerialPort="/dev/ttyUSB0"
						  else
						  	  uci set RS485UtilityConfigGeneric.rs485utilityconfig.SerialPort2="/dev/ttyUSB0"
						fi
				   else		  
				  ##fi
	                     detect_rs232_ports
	                     confirm_rs232_port
			            
							if [ "2c7c" = "$vendorid" ] && [ "6005" = "$productid" ] 
							then
								if echo "$board_name" | grep -qE "(IAB44-B|IAB44-C)";                                                                     
								then
				   					uci set RS232UtilityConfigGeneric.rs232utilityconfig.SerialPort="$SerialPort2"
				   				else
					   				uci set RS485UtilityConfigGeneric.rs485utilityconfig.SerialPort2="$SerialPort2"
				   				fi	
			   				else
				   				if echo "$board_name" | grep -qE "(IAB44-B|IAB44-C)";                                                                     
								then	
				   					uci set RS232UtilityConfigGeneric.rs232utilityconfig.SerialPort="$SerialPort2"
			   					else
				   					uci set RS485UtilityConfigGeneric.rs485utilityconfig.SerialPort2="$SerialPort2"
			   					fi
			   				fi
			   		fi			
   					
   				if echo "$board_name" | grep -qE "(IAB44-B|IAB44-C)";                                                                     
				then	
					uci commit RS232UtilityConfigGeneric
					sh /bin/UpdateConfigurationsGateway rs232PortUpadate
					sh /bin/UpdateConfigurationsGateway rs232utilitycfg
				else
					uci commit RS485UtilityConfigGeneric					
					sh /bin/UpdateConfigurationsGateway rs485port2cfg
					sh /bin/UpdateConfigurationsGateway rs485utilitycfg
				fi
				
				if [ "$Ser2netEnable2" = "2" ] && [ "$EMeterRS232Line1DataSourceEnable" = "1" ]
		        then  
					NoOfRS232EMetersInLine1=$(cat /Web_Page_Gateway_Apps/Common_GW_Files/DataSourcesConfig.cfg | grep NoOfRS232EMetersInLine1)
				    sed -i '/NoOfRS232EMetersInLine1/d' /root/SourceAppComponent/etc/Config/DataSourcesConfig.cfg
			        echo "NoOfRS232EMetersInLine1=$NoOfRS232EMetersInLine1" >> "${SourceConfigPath}.cfg"
			        ##sed -i '/NoOfRS232EMetersInLine1/d' /Web_Page_Gateway_Apps/Common_GW_Files/DataSourcesConfig.cfg
			        ##echo "NoOfRS232EMetersInLine1=$NoOfRS232DeviceCount" >> /Web_Page_Gateway_Apps/Common_GW_Files/DataSourcesConfig.cfg
		        fi
			fi
       fi

