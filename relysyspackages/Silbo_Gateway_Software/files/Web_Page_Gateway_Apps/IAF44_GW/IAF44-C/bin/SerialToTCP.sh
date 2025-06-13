#!/bin/sh
. /lib/functions.sh

# Paths and variables
SerialToTCPSerialcfg="/root/rtumd/etc/config/SerialPortConfig.cfg"
SerialToTCPTCPcfg="/root/rtumd/etc/config/TcpPortConfig.cfg"
SerialToTCPSerialcfg2="/root/rtumd2/etc/config/SerialPortConfig.cfg"
SerialToTCPTCPcfg2="/root/rtumd2/etc/config/TcpPortConfig.cfg"
SerialToTCPUcifile="/etc/config/portconfig"
noOfClients=0
noOfClients2=0

# Function to update TCP clients
UpdateTCPClients() {
    local section="$1"
    config_get clientIP "$section" clientIP
    config_get clientPort "$section" clientPort
    config_get SlaveID "$section" SlaveID
    config_get ResponseWaitTime "$section" ResponseWaitTime
    config_get ConnectionTimeout "$section" ConnectionTimeout

    config_get clientIP2 "$section" clientIP2
    config_get clientPort2 "$section" clientPort2
    config_get SlaveID2 "$section" SlaveID2
    config_get ResponseWaitTime2 "$section" ResponseWaitTime2
    config_get ConnectionTimeout2 "$section" ConnectionTimeout2

    # Write to first TCP config
    if [ -n "$clientIP" ]; then
        noOfClients=$((noOfClients + 1))
        {
            echo "clientIP${noOfClients} = \"$clientIP\""
            echo "clientPort${noOfClients} = $clientPort"
            echo "SlaveID${noOfClients} = $SlaveID"
            echo "ResponseWaitTime${noOfClients} = $ResponseWaitTime"
            echo "ConnectionTimeout${noOfClients} = $ConnectionTimeout"
            echo ""
        } >> "$SerialToTCPTCPcfg"
    fi

    # Write to second TCP config
    if [ -n "$clientIP2" ]; then
        noOfClients2=$((noOfClients2 + 1))
        {
            echo "clientIP${noOfClients2} = \"$clientIP2\""
            echo "clientPort${noOfClients2} = $clientPort2"
            echo "SlaveID${noOfClients2} = $SlaveID2"
            echo "ResponseWaitTime${noOfClients2} = $ResponseWaitTime2"
            echo "ConnectionTimeout${noOfClients2} = $ConnectionTimeout2"
            echo ""
        } >> "$SerialToTCPTCPcfg2"
    fi
}

    
    
    
    
    UpdateSerialToTCP() {
    config_get mbusdBaudrate1 "portconfig1" mbusdBaudrate1
    config_get mbusdParity1 "portconfig1" mbusdParity1
    config_get mbusdNoOfStopbits1 "portconfig1" mbusdNoOfStopbits1
    config_get mbusdDatabits1 "portconfig1" mbusdDatabits1
    config_get mbusdmaxretries1 "portconfig1" mbusdmaxretries1
    config_get mbusddelaybetweeneachrequest1 "portconfig1" mbusddelaybetweeneachrequest1
    config_get mbusdinactivitytimeout1 "portconfig1" mbusdinactivitytimeout1

    # Debugging: Print retrieved values
    echo "DEBUG: Retrieved values:"
    echo "Baudrate: $mbusdBaudrate1, Parity: $mbusdParity1, Stopbits: $mbusdNoOfStopbits1"
    echo "Databits: $mbusdDatabits1, MaxRetries: $mbusdmaxretries1"
    echo "DelayBetweenRequests: $mbusddelaybetweeneachrequest1, InactivityTimeout: $mbusdinactivitytimeout1"

    {
        echo "SerialPort = \"/dev/ttyS1\""
        echo "Baudrate = $mbusdBaudrate1"
        echo "Parity = $mbusdParity1"
        echo "Databits = $mbusdDatabits1"
        echo "Stopbits = $mbusdNoOfStopbits1"
        echo ""
    } >> "$SerialToTCPSerialcfg"


    

    {
        echo "AdressFamily = \"IPv4\""
        echo "NoOfRetries = $mbusdmaxretries1"
        echo "DelayBetweenConnectionRequest = $mbusddelaybetweeneachrequest1"
        echo "InactivityTimeout = $mbusdinactivitytimeout1"
        echo "MaxNumberOfThreads = 2"
        echo "LogLevel = 1"
        echo ""
    } >> "$SerialToTCPTCPcfg"
}



# Function to update Serial to TCP configuration (Instance 2)
UpdateSerialToTCP2() {
    config_get mbusdBaudrate2 "portconfig2" mbusdBaudrate2
    config_get mbusdParity2 "portconfig2" mbusdParity2
    config_get mbusdNoOfStopbits2 "portconfig2" mbusdNoOfStopbits2
    config_get mbusdDatabits2 "portconfig2" mbusdDatabits2

    config_get mbusdmaxretries2 "portconfig2" mbusdmaxretries2
    config_get mbusddelaybetweeneachrequest2 "portconfig2" mbusddelaybetweeneac hrequest2
    config_get mbusdinactivitytimeout2 "portconfig2" mbusdinactivitytimeout2
    
    
	
	config_get mbusdtcpIP2 						"portconfig"		mbusdtcpIP2
	config_get mbusdtcpslaveport2				"portconfig"		mbusdtcpslaveport2
	config_get mbusdresponsewaittime2 			"portconfig"		mbusdresponsewaittime2
	
    

    {
        board_name=$(cat /tmp/sysinfo/board_name)
        if echo "$board_name" | grep -qE "(PC3|GD)"; then
            SerialPort2="/dev/ttyS2"
        else
            SerialPort2=$(uci get RS232UtilityConfigGeneric.rs232utilityconfig.SerialPort)
        fi
        echo "SerialPort = \"$SerialPort2\""
        echo "Baudrate = $mbusdBaudrate2"
        echo "Parity = $mbusdParity2"
        echo "Databits = $mbusdDatabits2"
        echo "Stopbits = $mbusdNoOfStopbits2"
        echo ""
    } >> "$SerialToTCPSerialcfg2"

    {
        echo "AdressFamily = \"IPv4\""
        echo "NoOfRetries = $mbusdmaxretries2"
        echo "DelayBetweenConnectionRequest = $mbusddelaybetweeneachrequest2"
        echo "InactivityTimeout = $mbusdinactivitytimeout2"
        echo "MaxNumberOfThreads = 2"
        echo "LogLevel = 1"
        echo ""
    } >> "$SerialToTCPTCPcfg2"
}

# Clean up existing configuration files
rm -rf "$SerialToTCPSerialcfg"
rm -rf "$SerialToTCPTCPcfg"
rm -rf "$SerialToTCPSerialcfg2"
rm -rf "$SerialToTCPTCPcfg2"

# Load configuration and update files
config_load "$SerialToTCPUcifile"
UpdateSerialToTCP
UpdateSerialToTCP2
config_foreach UpdateTCPClients tcpClient_1
config_foreach UpdateTCPClients tcpClient_2

# Append the number of clients to configuration files
echo "noOfClients = $noOfClients" >> "$SerialToTCPTCPcfg"
echo "noOfClients2 = $noOfClients2" >> "$SerialToTCPTCPcfg2"
