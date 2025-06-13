#!/bin/sh
max_sleep_time=30
while true; do
    start_time=$(date +%s)
    #device details
    Device_id=$(uci get boardconfig.board.serialnum)
    uuidk=$(uci get openwisp.http.uuid)
    if [ $? -eq 0 ]; then
        echo "$uuidk"
    else
        uuidk="NA"
    fi
    WiFi_ssid=$(uci get sysconfig.wificonfig.wifi1ssid)
    firmWare_version=$(uci get boardconfig.board.FirmwareVer)
    ipk_version=$(uci get boardconfig.board.ApplicationSwVer)
    combined_version="${firmWare_version}_${ipk_version}"
    Gateway_firmware_version=$(uci get boardconfig.board.GWFirmwareVer 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "$Gateway_firmware_version"
    else
        Gateway_firmware_version="NA"
    fi
    Ethernet_Wan_Mac=$(uci get boardconfig.board.wanmacid)
    DEVICE_MODEL=$(uci get boardconfig.board.model)
    #device temperature
    board_name=$(cat /tmp/sysinfo/board_name)
    if [ "$board_name" == "Silbo_IE44A-EX1" ]; then
        Temperature=$(cat /sys/class/hwmon/hwmon0/temp1_input)
        ConvertedTemperature=$(awk "BEGIN { printf \"%.1f\", $Temperature * 0.000625 }")
        # ConvertedTemperature=$((Temperature * 625 / 1000000))
        DEVICE_Temperature="${ConvertedTemperature}°C"
    else
        DEVICE_Temperature=$(iwpriv ra0 stat | grep CurrentTemperature | awk '{print $3 "°C"}')
    fi
    #device uptime
    formatted_uptime=$(cat /proc/uptime | awk '{ printf "%dd:%02dh:%02dm:%02ds\n", $1 / 86400, ($1 % 86400) / 3600, ($1 % 3600) / 60, $1 % 60 }')

    # memory related
    mem_info=$(ubus call system info | jsonfilter -e '@.memory')
    total_mem=$(echo "$mem_info" | jsonfilter -e '@.total')
    total_memory_mb=$((total_mem / 1024 / 1024))
    free_mem=$(echo "$mem_info" | jsonfilter -e '@.free')
    cached_mem=$(echo "$mem_info" | jsonfilter -e '@.cached')
    used_mem=$((total_mem - free_mem - cached_mem))
    RAM_USAGE_mb=$((used_mem / 1024 / 1024))
    RAM_usage_total_per=$(awk "BEGIN {printf \"%.2f%%\", ($RAM_USAGE_mb / $total_memory_mb) * 100}")
    RAM_usage_total="${RAM_USAGE_mb}M/${total_memory_mb}M(${RAM_usage_total_per})"

    FLASH_usage_mb=$(df -h | grep "/dev/mtdblock6" | awk '{print $3}')
    FLASH_total_mb=$(df -h | grep "/dev/mtdblock6" | awk '{print $2}')
    FLASH_usage_total_per=$(df -h | grep "/dev/mtdblock6" | awk '{print $5}')
    FLASH_usage_total="${FLASH_usage_mb}/${FLASH_total_mb}(${FLASH_usage_total_per})"

    CPU_USAGE=$(uptime | awk -F'load average: ' '{print $2}' | awk -F', ' '{print $1", "$2", "$3}')
    CPU_USAGE_modified=$(echo "$CPU_USAGE" | sed 's/,/_/g')
    CPU_USAGE_AVG_FLOAT=$(uptime | awk -F'load average: ' '{print $2}' | awk -F', ' '{print ($1 + $2 + $3) / 3}')
    CPU_USAGE_AVG=$(printf "%.2f" "$CPU_USAGE_AVG_FLOAT")
    sleep 3

    #ipaddress LAN
    ifnamelan=$(uci get network.SW_LAN.ifname 2>/dev/null)
    landetail=$(ifconfig $ifnamelan | grep -oE 'inet addr:[0-9.]+ ' | grep -oE '[0-9.]+')
    if [ -z "$landetail" ]; then
        landetail="NA"
    fi

    # connection Type
		deviceActiveInetInterfaceName=$(mwan3 interfaces | grep -i "online" | awk '{print $2}')
		deviceActiveInetInterfaceName=$(echo "$deviceActiveInetInterfaceName" | tr '\n' ' ')
		Device_ports=""
		Device_status=""
		Device_ip=""
		Device_UPTIME=""
		for interface in $deviceActiveInetInterfaceName; do
			Device_status_value=$(mwan3 interfaces | grep "$interface" | awk '{print $4}')
			ifname=$(uci get network.$interface.ifname 2>/dev/null)
			WANdetail=$(ifconfig "$ifname" 2>/dev/null | grep -oE 'inet addr:[0-9.]+' | grep -oE '[0-9.]+')
			Internet_UPTIME=$(mwan3 interfaces | grep "$interface" | awk '{print $5}' | sed 's/,$//')
			change_Internet_UPTIME=$(echo "$Internet_UPTIME" | awk -F ":" '{
				total_seconds = ($1 * 3600) + ($2 * 60) + $3;
				days = int(total_seconds / 86400);
				hours = int((total_seconds % 86400) / 3600);
				minutes = int((total_seconds % 3600) / 60);
				seconds = total_seconds % 60;
				printf "%dd:%02dh:%02dm:%02ds", days, hours, minutes, seconds
			}')
			# Append values with " || " separator
			if [ -z "$Device_ports" ]; then
				Device_ports="$interface"
				Device_status="$Device_status_value"
				Device_ip="$WANdetail"
				Device_UPTIME="$change_Internet_UPTIME"
			else
				Device_ports="$Device_ports || $interface"
				Device_status="$Device_status || $Device_status_value"
				Device_ip="$Device_ip || $WANdetail"
				Device_UPTIME="$Device_UPTIME || $change_Internet_UPTIME"
			fi
		done
		# Handle empty values
		[ -z "$Device_ports" ] && Device_ports="NA"
		[ -z "$Device_ip" ] && Device_ip="NA"
		[ -z "$Device_status" ] && Device_status="NA"
		[ -z "$Device_UPTIME" ] && Device_UPTIME="NA"
		# Assign final values
		RouterWANporttimedetail="$Device_ports"
		RouterWANipdetail="$Device_ip"
		RouterWANstatusdetail="$Device_status"
		RouterWANuptimedetail="$Device_UPTIME"
		# Output results
		echo "Device_ports= $Device_ports"
		echo "Device_status= $Device_status"
		echo "Device_ip= $Device_ip"
		echo "Device_UPTIME= $Device_UPTIME"
    #Cellular mode
    Cellular_Mode=$(uci get modemstatus.modemstatus.CellularOperationMode)
    if [ "$Cellular_Mode" = "dualcellularsinglesim" ];then
            Cellular_Mode="DualCellular-Singlesim"
    elif [ "$Cellular_Mode" = "singlecellularsinglesim" ];then
            Cellular_Mode="SingleCellular-Singlesim"
    else
            Cellular_Mode="SingleCellular-Dualsim"
    fi
    if [ -z "$Cellular_Mode" ]; then
            Cellular_Mode="NA"
    fi
    #device CPIN_STATUS
        CPIN_STATUS=$(uci get modemstatus.modemstatus.PinState 2>/dev/null)
        attempts=0
        max_attempts=3
        while { [ -z "$CPIN_STATUS" ] || [[ "$CPIN_STATUS" == "-" ]] || [[ "$CPIN_STATUS" == *"Entry not found"* ]] || [[ "$CPIN_STATUS" == "ERRORERROR" ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            CPIN_STATUS=$(uci get modemstatus.modemstatus.PinState 2>/dev/null)
        done

        if [ -z "$CPIN_STATUS" ] || [[ "$CPIN_STATUS" == "-" ]] || [[ "$CPIN_STATUS" == *"Entry not found"* ]] || [[ "$CPIN_STATUS" == "ERRORERROR" ]]; then
            CPIN_STATUS="NA"
        fi
        if [ -z "$CPIN_STATUS" ]; then
            CPIN_STATUS="NA"
        fi
    # mobile operator 
    if [ "$CPIN_STATUS" = "READY" ]; then
        MOBILE_Operator=$(uci get modemstatus.modemstatus.Operator 2>/dev/null)
        attempts=0
        max_attempts=3
        while { [ -z "$MOBILE_Operator" ] || [[ "$MOBILE_Operator" == "-" ]] || [[ "$MOBILE_Operator" == *"Entry not found"* ]] || [[ "$MOBILE_Operator" == "ERRORERROR" ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            MOBILE_Operator=$(uci get modemstatus.modemstatus.Operator 2>/dev/null)
        done

        if [ -z "$MOBILE_Operator" ] || [[ "$MOBILE_Operator" == "-" ]] || [[ "$MOBILE_Operator" == *"Entry not found"* ]] || [[ "$MOBILE_Operator" == "ERRORERROR" ]]; then
            MOBILE_Operator="NA"
        fi
    else
            MOBILE_Operator="NA"
    fi
    #Mobile_Operator_Code_B
    if [ "$CPIN_STATUS" = "READY" ]; then
        Mobile_Operator_Code_B=$(uci get modemstatus.modemstatus.OperatorCode 2>/dev/null)
        attempts=0
        max_attempts=3
        while { [ -z "$Mobile_Operator_Code_B" ] || [[ "$Mobile_Operator_Code_B" == "-" ]] || [[ "$Mobile_Operator_Code_B" == *"Entry not found"* ]] || [[ "$Mobile_Operator_Code_B" == "ERRORERROR" ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            Mobile_Operator_Code_B=$(uci get modemstatus.modemstatus.OperatorCode 2>/dev/null)
        done

        if [ -z "$Mobile_Operator_Code_B" ] || [[ "$Mobile_Operator_Code_B" == "-" ]] || [[ "$Mobile_Operator_Code_B" == *"Entry not found"* ]] || [[ "$Mobile_Operator_Code_B" == "ERRORERROR" ]]; then
            Mobile_Operator_Code_B="NA"
        fi
    else
            Mobile_Operator_Code_B="NA"
    fi
    # device qccid
    if [ "$CPIN_STATUS" = "READY" ]; then
        deviceqccid=$(uci get system.system.qccid 2>/dev/null | xargs)
        attempts=0
        max_attempts=3
        while { [ -z "$deviceqccid" ] || [ "${#deviceqccid}" -le 10 ] || [[ "$deviceqccid" == "-" ]] || [[ "$deviceqccid" == *"Entry not found"* ]] || [[ "$deviceqccid" == "ERRORERROR" ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            deviceqccid=$(uci get system.system.qccid 2>/dev/null | xargs)
        done

        if [ -z "$deviceqccid" ] || [ "${#deviceqccid}" -le 10 ] || [[ "$deviceqccid" == "-" ]] || [[ "$deviceqccid" == *"Entry not found"* ]] || [[ "$deviceqccid" == "ERRORERROR" ]]; then
            deviceqccid="NA"
        fi
    else [ -z "$deviceqccid" ] || [ "${#deviceqccid}" -le 10 ]
            deviceqccid="NA"
    fi
    #device IMSI
    if [ "$CPIN_STATUS" = "READY" ]; then
        ACT_IMSI=$(uci get modemstatus.modemstatus.IMSI 2>/dev/null)
        attempts=0
        max_attempts=3
        while { [ -z "$ACT_IMSI" ] || [ "${#ACT_IMSI}" -le 10 ] || [[ "$ACT_IMSI" == "-" ]] || [[ "$ACT_IMSI" == *"Entry not found"* ]] || [[ "$ACT_IMSI" == "ERRORERROR" ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            ACT_IMSI=$(uci get modemstatus.modemstatus.IMSI 2>/dev/null)
        done

        if [ -z "$ACT_IMSI" ] || [ "${#ACT_IMSI}" -le 10 ] || [[ "$ACT_IMSI" == "-" ]] || [[ "$ACT_IMSI" == *"Entry not found"* ]] || [[ "$ACT_IMSI" == "ERRORERROR" ]]; then
            ACT_IMSI="NA"
        fi
    else [ -z "$ACT_IMSI" ] || [ "${#ACT_IMSI}" -le 10 ]
        ACT_IMSI="NA"
    fi
    #device makecsq mobile signal 
    if [ "$CPIN_STATUS" = "READY" ]; then
        makecsq=$(uci get modemstatus.modemstatus.SignalStrength 2>/dev/null)
        attempts=0
        max_attempts=3

        while { [ -z "$makecsq" ] || [[ "$makecsq" == "-" ]] || [[ "$makecsq" == *"Entry not found"* ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            makecsq=$(uci get modemstatus.modemstatus.SignalStrength 2>/dev/null)
        done

        if [ -z "$makecsq" ] || [[ "$makecsq" == "-" ]] || [[ "$makecsq" == *"Entry not found"* ]]; then
            makecsq="NA"
        fi
    else
        makecsq="NA"
    fi
    #device RSRP_SINR
    if [ "$CPIN_STATUS" = "READY" ]; then
        RSRP_signal=$(uci get modemstatus.modemstatus.RSRP 2>/dev/null)
        attempts=0
        max_attempts=3

        while { [ -z "$RSRP_signal" ] || [[ "$RSRP_signal" == "-" ]] || [[ "$RSRP_signal" == *"Entry not found"* ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3  
            RSRP_signal=$(uci get modemstatus.modemstatus.RSRP 2>/dev/null)
        done

        if [ -z "$RSRP_signal" ] || [[ "$RSRP_signal" == "-" ]] || [[ "$RSRP_signal" == *"Entry not found"* ]]; then
            RSRP_SINR_COMBO="NA"
            RSRP_SINR_COMBO_modified="NA"
        else
            SINR_signal=$(uci get modemstatus.modemstatus.SINR 2>/dev/null)
            attempts=0

            while { [ -z "$SINR_signal" ] || [[ "$SINR_signal" == "-" ]] || [[ "$SINR_signal" == *"Entry not found"* ]]; } && [ $attempts -lt $max_attempts ]; do
                attempts=$((attempts + 1))
                sleep 3  
                SINR_signal=$(uci get modemstatus.modemstatus.SINR 2>/dev/null)
            done

            if [ -z "$SINR_signal" ] || [[ "$SINR_signal" == "-" ]] || [[ "$SINR_signal" == *"Entry not found"* ]]; then
                RSRP_SINR_COMBO="NA"
                RSRP_SINR_COMBO_modified="NA"
            else
                RSRP_SINR_COMBO="${RSRP_signal} dB ${SINR_signal} dB"
                RSRP_SINR_COMBO_pro="${RSRP_signal} dB__${SINR_signal} dB"
                RSRP_SINR_COMBO_modified=${RSRP_SINR_COMBO_pro}
            fi
        fi
    else
        RSRP_SINR_COMBO="NA"
        RSRP_SINR_COMBO_modified="NA"
    fi
    #device Network_type
    if [ "$CPIN_STATUS" = "READY" ]; then
        NetworkType=$(uci get modemstatus.modemstatus.Connected 2>/dev/null)
        attempts=0
        max_attempts=3

        while { [ -z "$NetworkType" ] || [[ "$NetworkType" == "-" ]] || [[ "$NetworkType" == *"Entry not found"* ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            NetworkType=$(uci get modemstatus.modemstatus.Connected 2>/dev/null)
        done

        if [ -z "$NetworkType" ] || [[ "$NetworkType" == "-" ]] || [[ "$NetworkType" == *"Entry not found"* ]]; then
            NetworkType="NA"
        fi
    else
        NetworkType="NA"
    fi
     
    # daily SIM1 data usage
    upload1=$(uci get modemstatus.modemstatus.SentToday1 2>/dev/null)
    Recived1=$(uci get modemstatus.modemstatus.ReceivedToday1 2>/dev/null)
    total_daily_datausage1=$(awk "BEGIN {print $upload1 + $Recived1}")
    dailydata_SIM1="Total:${total_daily_datausage1} MB Tx:${upload1} MB Rx:${Recived1} MB"
    # daily SIM1 data usage
    upload2=$(uci get modemstatus.modemstatus.SentToday2 2>/dev/null)
    Recived2=$(uci get modemstatus.modemstatus.ReceivedToday2 2>/dev/null)
    total_daily_datausage2=$(awk "BEGIN {print $upload2 + $Recived2}")
    dailydata_SIM2="Total:${total_daily_datausage2} MB Tx:${upload2} MB Rx:${Recived2} MB"

    Cellular_WAN_Interface_dailydata="SIM1=$dailydata_SIM1\nSIM2=$dailydata_SIM2"

    #monthly SIM1 data usage
    monthlysimupload1=$(uci get modemstatus.modemstatus.msent1 2>/dev/null)
    monthlysimrecived1=$(uci get modemstatus.modemstatus.mreceived1 2>/dev/null)
    total_monthly_datausage1=$(awk "BEGIN {print $monthlysimupload1 + $monthlysimrecived1}")
    monthdata_SIM1="Total:${total_monthly_datausage1} MB Tx:${monthlysimupload1} MB Rx:${monthlysimrecived1} MB"
    #monthly SIM2 data usage
    monthlysimupload2=$(uci get modemstatus.modemstatus.msent2 2>/dev/null)
    monthlysimrecived2=$(uci get modemstatus.modemstatus.mreceived2 2>/dev/null)
    total_monthly_datausage2=$(awk "BEGIN {print $monthlysimupload2 + $monthlysimrecived2}")
    monthdata_SIM2="Total:${total_monthly_datausage2} MB Tx:${monthlysimupload2} MB Rx:${monthlysimrecived2} MB"

    Cellular_WAN_Interface_monthdata="SIM1=$monthdata_SIM1\nSIM2=$monthdata_SIM2"

    # device CREG_STATUS
    if [ "$CPIN_STATUS" = "READY" ]; then
        CREG_STATUS=$(uci get modemstatus.modemstatus.sim_Reg_State 2>/dev/null)
		if [ "$CREG_STATUS" = "1" ]; then
            CREG_STATUS="Registered" 
        elif [ "$CREG_STATUS" = "0" ]; then
            CREG_STATUS="Not registered" 
        elif [ "$CREG_STATUS" = "2" ]; then
            CREG_STATUS="Not registered" 
        elif [ "$CREG_STATUS" = "3" ]; then
            CREG_STATUS="Registration denied"
        elif [ "$CREG_STATUS" = "5" ]; then
            CREG_STATUS="Registered roaming"
        else
            CREG_STATUS="Unknown" 
        fi
        attempts=0
        max_attempts=3
        while { [ -z "$CREG_STATUS" ] || [[ "$CREG_STATUS" == "-" ]] || [[ "$CREG_STATUS" == *"Entry not found"* ]] || [[ "$CREG_STATUS" == "ERRORERROR" ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            CREG_STATUS=$(uci get modemstatus.modemstatus.sim_Reg_State 2>/dev/null)
            if [ "$CREG_STATUS" = "1" ]; then
				CREG_STATUS="Registered" 
			elif [ "$CREG_STATUS" = "0" ]; then
				CREG_STATUS="Not registered" 
			elif [ "$CREG_STATUS" = "2" ]; then
				CREG_STATUS="Not registered" 
			elif [ "$CREG_STATUS" = "3" ]; then
				CREG_STATUS="Registration denied"
			elif [ "$CREG_STATUS" = "5" ]; then
				CREG_STATUS="Registered roaming"
			else
				CREG_STATUS="Unknown" 
			fi
        done

        if [ -z "$CREG_STATUS" ] || [[ "$CREG_STATUS" == "-" ]] || [[ "$CREG_STATUS" == *"Entry not found"* ]] || [[ "$CREG_STATUS" == "ERRORERROR" ]]; then
            CREG_STATUS="Not registered"
        fi
    else 
        CREG_STATUS="NA"
    fi
    #device CGReg_STATUS
    if [ "$CPIN_STATUS" = "READY" ]; then
        CGREG_STATUS=$(uci get modemstatus.modemstatus.sim_CGReg_State 2>/dev/null)
		if [ "$CGREG_STATUS" = "1" ] || [ "$CGREG_STATUS" = "5" ]; then
            CGREG_STATUS="Registered" 
        else
            CGREG_STATUS="Not registered" 
        fi
        attempts=0
        max_attempts=3
        while { [ -z "$CGREG_STATUS" ] || [[ "$CGREG_STATUS" == "-" ]] || [[ "$CGREG_STATUS" == *"Entry not found"* ]] || [[ "$CGREG_STATUS" == "ERRORERROR" ]]; } && [ $attempts -lt $max_attempts ]; do
            attempts=$((attempts + 1))
            sleep 3
            CGREG_STATUS=$(uci get modemstatus.modemstatus.sim_CGReg_State 2>/dev/null)
			if [ "$CGREG_STATUS" = "1" ] || [ "$CGREG_STATUS" = "5" ]; then
				CGREG_STATUS="Registered" 
			else
				CGREG_STATUS="Not registered" 
			fi
        done

        if [ -z "$CGREG_STATUS" ] || [[ "$CGREG_STATUS" == "-" ]] || [[ "$CGREG_STATUS" == *"Entry not found"* ]] || [[ "$CGREG_STATUS" == "ERRORERROR" ]]; then
            CGREG_STATUS="Not registered"
        fi
    else 
        CGREG_STATUS="NA"
    fi
    #device dhcp
    num_DHCP_Lease=$(cat /tmp/dhcp.leases | wc -l)
    if [ -z "$num_DHCP_Lease" ]; then
        num_DHCP_Lease="NA"
    fi

    cellular_Control=$(uci get sysconfig.sysconfig.enablecellular)
    if [ "$cellular_Control" = "0" ]; then
        Cellular_Mode="NA"
        CPIN_STATUS="NA"
        deviceqccid="NA"
        ACT_IMSI="NA"
        MOBILE_Operator="NA"
        Mobile_Operator_Code_B="NA"
        CREG_STATUS="NA"
        CGREG_STATUS="NA"
        NetworkType="NA"
        makecsq="NA"
        RSRP_SINR_COMBO="NA"
        RSRP_SINR_COMBO_modified="NA"
        Cellular_WAN_Interface_dailydata="NA"
        Cellular_WAN_Interface_monthdata="NA"
	fi
    
  
    # last poweroff & poweron details
    last_line=$(tail -n 1 /root/ConfigFiles/PowerOnOFF_reason/Reboot_Details.txt)
    LAST_Power_OFF_time=$(echo "$last_line" | awk -F',' '{print $2}')
    reason=$(echo "$last_line" | awk -F',' '{print $3}')
    # Last_PowerON_time=$(echo "$last_line" | awk -F',' '{print $4}')
    Last_PowerON_time=$(uptime -s)
    sleep 3
    csqtype="NA"

    rm /root/Device_health/Device_health_value.txt
    sleep 1
    touch /root/Device_health/Device_health_value.txt

    echo "$Device_id,$DEVICE_MODEL,$combined_version,$Gateway_firmware_version,$Ethernet_Wan_Mac,$formatted_uptime,$CPU_USAGE_AVG,$RAM_usage_total,$FLASH_usage_total,$WiFi_ssid,$num_DHCP_Lease,$RouterWANporttimedetail,$RouterWANstatusdetail,$RouterWANuptimedetail,$RouterWANipdetail,$landetail,$Cellular_Mode,$CPIN_STATUS,$deviceqccid,$ACT_IMSI,$MOBILE_Operator,$Mobile_Operator_Code_B,$CREG_STATUS,$CGREG_STATUS,$NetworkType,$makecsq,$RSRP_SINR_COMBO_modified,$Cellular_WAN_Interface_dailydata,$Cellular_WAN_Interface_monthdata,$LAST_Power_OFF_time,$reason,$Last_PowerON_time,$DEVICE_Temperature,$uuidk,$CPU_USAGE_modified,$csqtype" > /root/Device_health/Device_health_value.txt

data=$(cat <<EOF
{
   "Device_ID": "$Device_id",
   "Device_Model": "$DEVICE_MODEL",
   "Router_Firmware_Version": "$combined_version",
   "Gateway_Firmware_Version": "$Gateway_firmware_version",
   "Ethernet_WAN_MAC_ID": "$Ethernet_Wan_Mac",
   "System_Uptime": "$formatted_uptime",
   "Average_CPU_Usage": "$CPU_USAGE_AVG",
   "RAM_Usage": "$RAM_usage_total",
   "Flash_Usage": "$FLASH_usage_total",
   "WiFi_SSID": "$WiFi_ssid",
   "No_of_DHCP_Leases": "$num_DHCP_Lease",
   "Connection_Type": "$RouterWANporttimedetail",
   "Connection_Status": "$RouterWANstatusdetail",
   "Internet_Uptime": "$RouterWANuptimedetail",
   "Active_WAN_IP": "$RouterWANipdetail",
   "LAN_IP": "$landetail",
   "Cellular_Type": "$Cellular_Mode",
   "CPIN_Status": "$CPIN_STATUS",
   "ICCID": "$deviceqccid",
   "IMSI": "$ACT_IMSI",
   "Mobile_Operator_Name": "$MOBILE_Operator",
   "Mobile_Operator_Code": "$Mobile_Operator_Code_B",
   "CREG_Status": "$CREG_STATUS",
   "CGATT_Status": "$CGREG_STATUS",
   "SIM_RAT": "$NetworkType",
   "Mobile_Signal_CSQ": "$makecsq",
   "RSRP_SINR": "$RSRP_SINR_COMBO",
   "Cellular_WAN_Statistics_Daily": "$Cellular_WAN_Interface_dailydata",
   "Cellular_WAN_Statistics_Monthly": "$Cellular_WAN_Interface_monthdata",
   "Device_Last_PowerOFF_Time": "$LAST_Power_OFF_time",
   "Device_Last_PowerOFF_Reason": "$reason",
   "Device_Last_PowerON_Time": "$Last_PowerON_time",
   "Device_Temperature": "$DEVICE_Temperature",  
   "Device_UUID": "$uuidk",
    "Json_Data": {
    "CPU_avg": "$CPU_USAGE",
    "CSQ": "$csqtype"
    }
}
EOF
)
    echo "$data" 

    #log file for health
    LOG_DIR=/root/Router_Logs/SHMAPP_Log
    LOG_FILE=health_log_usage.txt
    MAX_FILES=2
    MAX_SIZE=500

    # check if the log directory exists, create it if it doesn't
    if [ ! -d "$LOG_DIR" ]; then
        echo "Creating log directory: $LOG_DIR"
        mkdir -p "$LOG_DIR"
    fi
    # check if the log file exists, create it if it doesn't
    if [ ! -f "$LOG_DIR/$LOG_FILE" ]; then
        echo "Creating log file: $LOG_DIR/$LOG_FILE"
        touch "$LOG_DIR/$LOG_FILE"
    fi
    # check the size of the current log file, rotate it if necessary
    if [ "$(wc -c < "$LOG_DIR/$LOG_FILE")" -gt "$MAX_SIZE" ]; then
        echo "Rotating log file: $LOG_DIR/$LOG_FILE"
        mv "$LOG_DIR/$LOG_FILE" "$LOG_DIR/$LOG_FILE.1"
        touch "$LOG_DIR/$LOG_FILE"
        truncate -s 0 "$LOG_DIR/$LOG_FILE"
    fi
    # check the number of log files, delete the oldest one if necessary
    if [ "$(ls -1 $LOG_DIR/$LOG_FILE* | wc -l)" -gt "$MAX_FILES" ]; then
        echo "Deleting oldest log file in directory: $LOG_DIR"
        rm -f "$(ls -1 $LOG_DIR/$LOG_FILE* | head -n 1)"
    fi


        protocol=$(uci get cloudconfigNH.cloudconfigNH.cloudprotocol)
	    if [ "$protocol" == "http" ]; then
            Requrl=$(uci get cloudconfigNH.cloudconfigNH.HTTPServerURL)
            if [ "$Requrl" = 2 ]; then           # custom url
                Reqcustomurl=$(uci get cloudconfigNH.cloudconfigNH.HTTPcustomURL)

                ReqHTTPport=$(uci get cloudconfigNH.cloudconfigNH.HTTPServerPort) 
                ReqHTTPauthcation=$(uci get cloudconfigNH.cloudconfigNH.httpauthenable)  
                ReqHTTPMode=$(uci get cloudconfigNH.cloudconfigNH.HTTPMethod)
                if [ "$ReqHTTPMode" = 0 ]; then
                    ReqHTTPMode="POST"
                else
                    ReqHTTPMode="GET"
                fi
                ReqHTTPusername=$(uci get cloudconfigNH.cloudconfigNH.username)
                ReqHTTPpassword=$(uci get cloudconfigNH.cloudconfigNH.password)
                ReqHTTPtoken=$(uci get cloudconfigNH.cloudconfigNH.entertoken)
                #Token
                if [ "$ReqHTTPauthcation" = "2" ]; 
                then
                    response=$(/usr/bin/curl -d "$data" -X $ReqHTTPMode  $Reqcustomurl:$ReqHTTPport -H "Authorization: $ReqHTTPtoken" -k)
                elif [ "$ReqHTTPauthcation" = "1" ]; 
                then
                    response=$(/usr/bin/curl -u $ReqHTTPusername:$ReqHTTPpassword -d "$data" -X $ReqHTTPMode $Reqcustomurl:$ReqHTTPport -k) 
                else
                    response=$(/usr/bin/curl -d "$data" -X $ReqHTTPMode $Reqcustomurl:$ReqHTTPport -k)
                fi
            else
                response=$(curl -k --request POST --url https://139.59.65.241/api/device-data/ --header 'Content-Type: application/json' --data "$data")
            fi
            if [[ "$response" == '{"message":"Data successfully saved"}' ]]; then
                send_time=$(date '+%Y-%m-%d %H:%M')
                echo "Data sent successfully["$response"].$send_time" >> "$LOG_DIR/$LOG_FILE" 
            elif [ "$response" == "OK" ]; then
                send_time=$(date '+%Y-%m-%d %H:%M')
                echo "Data sent successfully["$response"].$send_time" >> "$LOG_DIR/$LOG_FILE"
            else
                send_time=$(date '+%Y-%m-%d %H:%M')
                echo "DATA NOT SENT[$response].$send_time" >> "$LOG_DIR/$LOG_FILE"

                #fail file for health
                FAIL_DIR=/root/Router_Logs/SHMAPP_Log/failcase/
                FAIL_FILE=failures.json

                # check if the log directory exists, create it if it doesn't
                if [ ! -d "$FAIL_DIR" ]; then
                    echo "Creating log directory: $FAIL_DIR"
                    mkdir -p "$FAIL_DIR"
                fi
                # check if the log file exists, create it if it doesn't
                if [ ! -f "$FAIL_DIR/$FAIL_FILE" ]; then
                    echo "Creating log file: $LOG_DIR/$FAIL_FILE"
                    touch "$FAIL_DIR/$FAIL_FILE"
                fi
                # Failure data JSON object with timestamp
                failure_data="{\"timestamp\": \"$send_time\", \"data\": $data}"

                failure_file="/root/Router_Logs/SHMAPP_Log/failcase/failures.json"

                # Check if failures.json already exists and is not empty
                if [[ -s "$failure_file" ]]; then
                    # Append the new failure data to the existing JSON array
                    jq ". += [$failure_data]" "$failure_file" > "${failure_file}.tmp" && mv "${failure_file}.tmp" "$failure_file"
                else
                    echo "[$failure_data]" > "$failure_file"
                fi
            fi	
		else
                ReqToPublish()
                {
                    ReMqtttopic=$(uci get cloudconfigNH.cloudconfigNH.topicname)
                    ReMqttHost=$(uci get cloudconfigNH.cloudconfigNH.host)
                    ReMqttPort=$(uci get cloudconfigNH.cloudconfigNH.mqttport)
                    ReMqttQos=1
                    authcationpart=$(uci get cloudconfigNH.cloudconfigNH.mqttauthmode)
                    #username & password
                    UserName=$(uci get cloudconfigNH.cloudconfigNH.mqttusername)
                    PassWord=$(uci get cloudconfigNH.cloudconfigNH.mqttpassword)
                    #certificate
                    FIRST_FILE=$(ls /root/Device_health/certificate/ | head -1 | tail -1)
                    FIRST_FULL_PATH="/root/Device_health/certificate/$FIRST_FILE"
                    Sec_FILE=$(ls /root/Device_health/certificate/ | head -2 | tail -1)
                    Sec_FILE_FULL_PATH="/root/Device_health/certificate/$Sec_FILE"
                    third_FILE=$(ls /root/Device_health/certificate/ | head -3 | tail -1)
                    third_FILE_FULL_PATH="/root/Device_health/certificate/$third_FILE"
                    Fourth=$(ls /root/Device_health/certificate/ | head -4 | tail -1)
                    Fourth_FILE_FULL_PATH="/root/Device_health/certificate/$Fourth"

                    if [ "$authcationpart" = "3" ]; 
                    then
                            output=$(/usr/bin/mosquitto_pub -h "$ReMqttHost" -p "$ReMqttPort" -t "$ReMqtttopic" -m "$data" -q "$ReMqttQos")   
                    elif [ "$authcationpart" = "2" ]; 
                    then
                            output=$(/usr/bin/mosquitto_pub -h "$ReMqttHost" -p "$ReMqttPort" -t "$ReMqtttopic" -m "$data" -u "$UserName" -P "$PassWord" -q "$ReMqttQos") 
                    elif [ "$authcationpart" = "1" ]; 
                    then
                            output=$(/usr/bin/mosquitto_pub -h "$ReMqttHost" -p "$ReMqttPort" -t "$ReMqtttopic" -m "$data" -u "$UserName" -P "$PassWord" -q "$ReMqttQos" --cafile "$Fourth_FILE_FULL_PATH" --cert "$FIRST_FULL_PATH" --key "$Sec_FILE_FULL_PATH")       
                    else
                            output=$(/usr/bin/mosquitto_pub -h "$ReMqttHost" -p "$ReMqttPort" -t "$ReMqtttopic" -m "$data" -q "$ReMqttQos" --cafile "$Fourth_FILE_FULL_PATH" --cert "$FIRST_FULL_PATH" --key "$Sec_FILE_FULL_PATH")
                    fi        
                }
                ReqToPublish
                send_time=$(date '+%Y-%m-%d %H:%M')
                echo "MQTT message published with status. $send_time" >> "$LOG_DIR/$LOG_FILE" 
		fi

    # Define failure file path
    failure_file="/root/Router_Logs/SHMAPP_Log/failcase/failures.json" 

    # Check if failure file exists and is not empty
    if [[ -s "$failure_file" ]]; then
        # Keep resending until all entries in the failure file are successfully sent
        while [[ $(jq '. | length' "$failure_file") -gt 0 ]]; do
            # Read the first entry from failures.json
            first_entry=$(jq -c '.[0]' "$failure_file")
            data=$(echo "$first_entry" | jq -c '.data')
            sendt_time=$(echo "$first_entry" | jq -c '.timestamp')

            # Attempt to resend
            Requrl=$(uci get cloudconfigNH.cloudconfigNH.HTTPServerURL)
            if [ "$Requrl" = 2 ]; then
                Reqcustomurl=$(uci get cloudconfigNH.cloudconfigNH.HTTPcustomURL)
                # response=$(curl -k --request POST --url $Reqcustomurl --header 'Content-Type: application/json' --data "$data")
                ReqHTTPport=$(uci get cloudconfigNH.cloudconfigNH.HTTPServerPort) 
                ReqHTTPauthcation=$(uci get cloudconfigNH.cloudconfigNH.httpauthenable)  
                ReqHTTPMode=$(uci get cloudconfigNH.cloudconfigNH.HTTPMethod)
                if [ "$ReqHTTPMode" = 0 ]; then
                    ReqHTTPMode="POST"
                else
                    ReqHTTPMode="GET"
                fi
                ReqHTTPusername=$(uci get cloudconfigNH.cloudconfigNH.username)
                ReqHTTPpassword=$(uci get cloudconfigNH.cloudconfigNH.password)
                ReqHTTPtoken=$(uci get cloudconfigNH.cloudconfigNH.entertoken)
                #Token
                if [ "$ReqHTTPauthcation" = "2" ]; 
                then
                    response=$(/usr/bin/curl -d "$data" -X $ReqHTTPMode  $Reqcustomurl:$ReqHTTPport -H "Authorization: $ReqHTTPtoken" -k)
                elif [ "$ReqHTTPauthcation" = "1" ]; 
                then
                    response=$(/usr/bin/curl -u $ReqHTTPusername:$ReqHTTPpassword -d "$data" -X $ReqHTTPMode $Reqcustomurl:$ReqHTTPport -k) 
                else
                    response=$(/usr/bin/curl -d "$data" -X $ReqHTTPMode $Reqcustomurl:$ReqHTTPport -k)
                fi
            else
                response=$(curl -k --request POST --url https://139.59.65.241/api/device-data/ --header 'Content-Type: application/json' --data "$data")
            fi
            
            if [[ "$response" == '{"message":"Data successfully saved"}' ]]; then
                echo "Data resent successfully [$response] at $sendt_time" >> "$LOG_DIR/$LOG_FILE"
                # Remove the successfully sent entry from failures.json
                jq 'del(.[0])' "$failure_file" > "${failure_file}.tmp" && mv "${failure_file}.tmp" "$failure_file"
            elif [ "$response" == "OK" ]; then
                echo "Data resent successfully [$response] at $sendt_time" >> "$LOG_DIR/$LOG_FILE"
                # Remove the successfully sent entry from failures.json
                jq 'del(.[0])' "$failure_file" > "${failure_file}.tmp" && mv "${failure_file}.tmp" "$failure_file"
            else
                echo "Retry failed for data [$data]. Will retry again later."
                break  # Exit the inner loop to retry after the sleep period
            fi
        done

        # If all entries have been sent successfully, clear the file to an empty JSON array
        if [[ $(jq '. | length' "$failure_file") -eq 0 ]]; then
            echo "[]" > "$failure_file"
        fi
    fi

    # Calculate elapsed time and remaining sleep time to complete the 5-minute interval
    get_interval=$(uci get cloudconfigNH.cloudconfigNH.timesec)
    interval=$((get_interval * 60))
    end_time=$(date +%s)
    elapsed_time=$((end_time - start_time))
    remaining_time=$((interval - elapsed_time))

    if [ "$remaining_time" -le "$max_sleep_time" ]; then
        sleep $remaining_time
    else
        iterations=$(( remaining_time / max_sleep_time ))
        remaining_time=$(( remaining_time % max_sleep_time ))
        i=0
            while [ "$i" -le "$iterations" ]
            do
                echo "Iteration $i: Sleeping for $max_sleep_time seconds" 
                sleep $max_sleep_time
                i=$(( i + 1 ))
            done

        if [ "$remaining_time" -gt 0 ]; then
            sleep $remaining_time
        fi
    fi
done
