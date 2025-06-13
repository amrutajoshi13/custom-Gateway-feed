#!/bin/sh

rm /www/healtha_all_parameters.json/
sleep 1
touch /www/healtha_all_parameters.json
chmod 777 /www/healtha_all_parameters.json

# Read JSON values from the local file
Jsonvalues=$(cat /root/Device_health/Device_health_value.txt)

# Split the values from the file using IFS (Internal Field Separator)
IFS=',' read -r Device_id DEVICE_MODEL combined_version Gateway_firmware_version Ethernet_Wan_Mac formatted_uptime CPU_USAGE_AVG RAM_usage_total FLASH_usage_total WiFi_ssid num_DHCP_Lease Device_Connection_type Device_WAN_status Internet_UPTIME WANdetail landetail CPIN_STATUS deviceqccid ACT_IMSI MOBILE_Operator Mobile_Operator_Code_B CREG_STATUS CGATT_STATUS NetworkType makecsq RSRP_SINR_COMBO Cellular_WAN_Interface_dailydata Cellular_WAN_Interface_monthdata LAST_Power_OFF_time reason Last_PowerON_time DEVICE_Temperature uuidk CPU_USAGE csqtype<<EOF
$Jsonvalues
EOF

# Create JSON output with the extracted values
output=$(cat <<EOF
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
   "Connection_Type": "$Device_Connection_type",
   "Connection_Status": "$Device_WAN_status",
   "Internet_Uptime": "$Internet_UPTIME",
   "Active_WAN_IP": "$WANdetail",
   "LAN_IP": "$landetail",
   "CPIN_Status": "$CPIN_STATUS",
   "ICCID": "$deviceqccid",
   "IMSI": "$ACT_IMSI",
   "Mobile_Operator_Name": "$MOBILE_Operator",
   "Mobile_Operator_Code": "$Mobile_Operator_Code_B",
   "CREG_Status": "$CREG_STATUS",
   "CGATT_Status": "$CGATT_STATUS",
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

# Print the JSON output
echo "$output"  >> /www/healtha_all_parameters.json
