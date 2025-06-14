#!/bin/sh
Logfile="/root/ConfigFiles/Logs/AddIfaceLog.txt"


[ -n "$INCLUDE_ONLY" ] || {
	. /lib/functions.sh
	. ../netifd-proto.sh
	init_proto "$@"
}

proto_qmi_init_config() {
	available=1
	no_device=1
	proto_config_add_string "device:device"
	proto_config_add_string apn
	proto_config_add_string auth
	proto_config_add_string username
	proto_config_add_string password
	proto_config_add_string pincode
	proto_config_add_int delay
	proto_config_add_string modes
	proto_config_add_string pdptype
	proto_config_add_int profile
	proto_config_add_boolean dhcpv6
	proto_config_add_boolean autoconnect
	proto_config_add_int plmn
	proto_config_add_int timeout
	proto_config_add_int mtu
	proto_config_add_defaults
}

proto_qmi_setup() {
	local interface="$1"
	local dataformat connstat
	local device apn auth username password pincode delay modes pdptype
	local profile dhcpv6 autoconnect plmn timeout mtu $PROTO_DEFAULT_OPTIONS
	local ip4table ip6table
	local cid_4 pdh_4 cid_6 pdh_6
	local ip_6 ip_prefix_length gateway_6 dns1_6 dns2_6

	json_get_vars device apn auth username password pincode delay modes
	json_get_vars pdptype profile dhcpv6 autoconnect plmn ip4table
	json_get_vars ip6table timeout mtu $PROTO_DEFAULT_OPTIONS

	[ "$timeout" = "" ] && timeout="10"

	[ "$metric" = "" ] && metric="0"

	[ -n "$ctl_device" ] && device=$ctl_device

	[ -n "$device" ] || {
		echo "No control device specified"
		proto_notify_error "$interface" NO_DEVICE
		proto_set_available "$interface" 0
		return 1
	}

	[ -n "$delay" ] && sleep "$delay"

	device="$(readlink -f $device)"
	[ -c "$device" ] || {
		echo "The specified control device does not exist"
		proto_notify_error "$interface" NO_DEVICE
		proto_set_available "$interface" 0
		return 1
	}

	devname="$(basename "$device")"
	devpath="$(readlink -f /sys/class/usbmisc/$devname/device/)"
	ifname="$( ls "$devpath"/net )"
	[ -n "$ifname" ] || {
		echo "The interface could not be found."
		proto_notify_error "$interface" NO_IFACE
		proto_set_available "$interface" 0
		return 1
	}

	[ -n "$mtu" ] && {
		echo "Setting MTU to $mtu"
		/sbin/ip link set dev $ifname mtu $mtu
	}

	echo "Waiting for SIM initialization"
	local uninitialized_timeout=0
	while uqmi -s -d "$device" --get-pin-status | grep '"UIM uninitialized"' > /dev/null; do
		[ -e "$device" ] || return 1
		if [ "$uninitialized_timeout" -lt "$timeout" ]; then
			let uninitialized_timeout++
			sleep 1;
		else
			echo "SIM not initialized"
			proto_notify_error "$interface" SIM_NOT_INITIALIZED
			proto_block_restart "$interface"
			return 1
		fi
	done

	if uqmi -s -d "$device" --get-pin-status | grep '"Not supported"\|"Invalid QMI command"' > /dev/null; then
		[ -n "$pincode" ] && {
			uqmi -s -d "$device" --verify-pin1 "$pincode" > /dev/null || uqmi -s -d "$device" --uim-verify-pin1 "$pincode" > /dev/null || {
				echo "Unable to verify PIN"
				proto_notify_error "$interface" PIN_FAILED
				proto_block_restart "$interface"
				return 1
			}
		}
	else
		. /usr/share/libubox/jshn.sh
		json_load "$(uqmi -s -d "$device" --get-pin-status)"
		json_get_var pin1_status pin1_status
		json_get_var pin1_verify_tries pin1_verify_tries

		case "$pin1_status" in
			disabled)
				echo "PIN verification is disabled"
				;;
			blocked)
				echo "SIM locked PUK required"
				proto_notify_error "$interface" PUK_NEEDED
				proto_block_restart "$interface"
				return 1
				;;
			not_verified)
				[ "$pin1_verify_tries" -lt "3" ] && {
					echo "PIN verify count value is $pin1_verify_tries this is below the limit of 3"
					proto_notify_error "$interface" PIN_TRIES_BELOW_LIMIT
					proto_block_restart "$interface"
					return 1
				}
				if [ -n "$pincode" ]; then
					uqmi -s -d "$device" --verify-pin1 "$pincode" > /dev/null 2>&1 || uqmi -s -d "$device" --uim-verify-pin1 "$pincode" > /dev/null 2>&1 || {
						echo "Unable to verify PIN"
						proto_notify_error "$interface" PIN_FAILED
						proto_block_restart "$interface"
						return 1
					}
				else
					echo "PIN not specified but required"
					proto_notify_error "$interface" PIN_NOT_SPECIFIED
					proto_block_restart "$interface"
					return 1
				fi
				;;
			verified)
				echo "PIN already verified"
				;;
			*)
				echo "PIN status failed ($pin1_status)"
				proto_notify_error "$interface" PIN_STATUS_FAILED
				proto_block_restart "$interface"
				return 1
			;;
		esac
	fi

	[ -n "$plmn" ] && {
		local mcc mnc
		if [ "$plmn" = 0 ]; then
			mcc=0
			mnc=0
			echo "Setting PLMN to auto"
		else
			mcc=${plmn:0:3}
			mnc=${plmn:3}
			echo "Setting PLMN to $plmn"
		fi
		uqmi -s -d "$device" --set-plmn --mcc "$mcc" --mnc "$mnc" > /dev/null 2>&1 || {
			echo "Unable to set PLMN"
			proto_notify_error "$interface" PLMN_FAILED
			proto_block_restart "$interface"
			return 1
		}
	}

	# Cleanup current state if any
	uqmi -s -d "$device" --stop-network 0xffffffff --autoconnect > /dev/null 2>&1
        uqmi -s -d "$device" --set-ip-family ipv6 --stop-network 0xffffffff --autoconnect > /dev/null 2>&1

	# Go online
	uqmi -s -d "$device" --set-device-operating-mode online > /dev/null 2>&1

	# Set IP format
	uqmi -s -d "$device" --set-data-format 802.3 > /dev/null 2>&1
	uqmi -s -d "$device" --wda-set-data-format 802.3 > /dev/null 2>&1
	dataformat="$(uqmi -s -d "$device" --wda-get-data-format)"

        ip l set "$ifname" down
        echo "just set the interface with name: "$ifname" down"

	if [ "$dataformat" = '"raw-ip"' ]; then

		[ -f /sys/class/net/$ifname/qmi/raw_ip ] || {
			echo "Device only supports raw-ip mode but is missing this required driver attribute: /sys/class/net/$ifname/qmi/raw_ip"
			return 1
		}

		echo "Device does not support 802.3 mode. Informing driver of raw-ip only for $ifname .."
		echo "Y" > /sys/class/net/$ifname/qmi/raw_ip
                echo "wrote Y to raw_ip file"
	fi

	uqmi -s -d "$device" --sync > /dev/null 2>&1

        ip l set "$ifname" up
        echo "just set the interface with name: "$ifname" up"


	echo "Waiting for network registration"
	local registration_timeout=0
	while uqmi -s -d "$device" --get-serving-system | grep '"searching"' > /dev/null; do	
		[ -e "$device" ] || return 1
		if [ "$registration_timeout" -lt "$timeout" ]; then
			let registration_timeout++
                        echo "Value of registration_timeout and timeout is : $registration_timeout and $timeout"
			sleep 1;
		else
			echo "Network registration failed"
			proto_notify_error "$interface" NETWORK_REGISTRATION_FAILED
			proto_block_restart "$interface"
			return 1
		fi
	done
	date=$(date)
     registration_status=$(uqmi -s -d "$device" --set-client-id wds,6 --get-serving-system)
     echo "$date:[qmi.sh]registration_status - $registration_status" >> "$Logfile"
	[ -n "$modes" ] && uqmi -s -d "$device" --set-network-modes "$modes" > /dev/null 2>&1

	echo "Starting network $interface with modes set to : $modes"

	pdptype=$(echo "$pdptype" | awk '{print tolower($0)}')
	[ "$pdptype" = "ip" -o "$pdptype" = "ipv6" -o "$pdptype" = "ipv4v6" ] || pdptype="ip"

	if [ "$pdptype" = "ip" ]; then
		[ -z "$autoconnect" ] && autoconnect=1
		[ "$autoconnect" = 0 ] && autoconnect=""
	else
		[ "$autoconnect" = 1 ] || autoconnect=""
	fi

	[ "$pdptype" = "ip" -o "$pdptype" = "ipv4v6" ] && {
		cid_4=$(uqmi -s -d "$device" --get-client-id wds)
		if ! [ "$cid_4" -eq "$cid_4" ] 2> /dev/null; then
			echo "Unable to obtain client ID"
			proto_notify_error "$interface" NO_CID
			return 1
		fi

		uqmi -s -d "$device" --set-client-id wds,"$cid_4" --set-ip-family ipv4 > /dev/null 2>&1
                echo "Obtained Client ID for IPv4 of : $cid_4"
                echo "Using IPv4 apn value : $apn"
                echo "Using IPv4 profile value : $profile"
                echo "Using IPv4 auth value : $auth"
                echo "Using IPv4 username value : $username"
                echo "Using IPv4 password value : $password"
 		echo "going to execute new stop network command next before pdh_4 start network"
                #uqmi -s -d "$device" --stop-network 4294967295 --autoconnect 


		pdh_4=$(uqmi -s -d "$device" --set-client-id wds,"$cid_4" \
			--start-network \
			${apn:+--apn $apn} \
			${profile:+--profile $profile} \
			${auth:+--auth-type $auth} \
			${username:+--username $username} \
			${password:+--password $password} \
			${autoconnect:+--autoconnect})

		# pdh_4 is a numeric value on success
		if ! [ "$pdh_4" -eq "$pdh_4" ] 2> /dev/null; then
			echo "Unable to connect IPv4"
			uqmi -s -d "$device" --set-client-id wds,"$cid_4" --release-client-id wds > /dev/null 2>&1
			proto_notify_error "$interface" CALL_FAILED
			return 1
		fi
                echo "Received pdh_4 value of:  $pdh_4" 
		# Check data connection state
		connstat4=$(uqmi -s -d "$device" --set-client-id wds,"$cid_4" --get-data-status)
                echo "connstat4 on IPv4 is : $connstat4"
                date=$(date)
                IPV4_address=$(uqmi -s -d $device --set-client-id wds,$cid_4 --get-current-settings)  > /dev/null 2>&1              
                echo "$date:[qmi.sh script] ipv4 address - $IPV4_address" >> "$Logfile"
		[ "$connstat4" == '"connected"' ] || {
			echo "No data link!"
			uqmi -s -d "$device" --set-client-id wds,"$cid_4" --release-client-id wds > /dev/null 2>&1
			proto_notify_error "$interface" CALL_FAILED
			return 1
		}
	}

	[ "$pdptype" = "ipv6" -o "$pdptype" = "ipv4v6" ] && {
		cid_6=$(uqmi -s -d "$device" --get-client-id wds)
		if ! [ "$cid_6" -eq "$cid_6" ] 2> /dev/null; then
			echo "Unable to obtain client ID"
			proto_notify_error "$interface" NO_CID
			return 1
		fi

		#uqmi -s -d "$device" --set-client-id wds,"$cid_6" --set-ip-family ipv6 > /dev/null 2>&1
                echo "Going to execute set ip family ipv6 command now"
		uqmi -s -d "$device" --set-client-id wds,"$cid_6" --set-ip-family ipv6  
                echo "Obtained IPv6 Client ID of : $cid_6"
                echo "Using IPv6 apn value : $apn"
                echo "Using IPv6 profile value : $profile"
                echo "Using IPv6 auth value : $auth"
                echo "Using IPv6 username value : $username"
                echo "Using IPv6 password value : $password"
 		echo "going to execute new stop network command next before pdh_6 start network"
                uqmi -s -d "$device" --stop-network 4294967295 --autoconnect 

		pdh_6=$(uqmi -s -d "$device" --set-client-id wds,"$cid_6" \
			--start-network --ip-family ipv6 \
			${apn:+--apn $apn} \
			${profile:+--profile $profile} \
			${auth:+--auth-type $auth} \
			${username:+--username $username} \
			${password:+--password $password} \
			${autoconnect:+--autoconnect})
                echo "Received pdh_6 value of:  $pdh_6" 

		# pdh_6 is a numeric value on success
		if ! [ "$pdh_6" -eq "$pdh_6" ] 2> /dev/null; then
			echo "Unable to connect IPv6"
			uqmi -s -d "$device" --set-client-id wds,"$cid_6" --release-client-id wds > /dev/null 2>&1
                        
			proto_notify_error "$interface" CALL_FAILED
			return 1
		fi

		# Check data connection state
		date=$(date)
		connstat6=$(uqmi -s -d "$device" --set-client-id wds,"$cid_6" --get-data-status)
                echo "connstat6 on IPv6 is : $connstat6" 
        IPV6_address=$(uqmi -s -d $device --set-client-id wds,$cid_6 --get-current-settings)  > /dev/null 2>&1              
		echo "$date:[qmi.sh script] ipv6 address - $IPV6_address" >> "$Logfile"
		[ "$connstat6" == '"connected"' ] || {
			echo "No data link!"
			uqmi -s -d "$device" --set-client-id wds,"$cid_6" --release-client-id wds > /dev/null 2>&1
			proto_notify_error "$interface" CALL_FAILED
			return 1
		}
	}

	echo "Setting up $ifname"
	proto_init_update "$ifname" 1
	proto_set_keep 1
	proto_add_data
	[ -n "$pdh_4" ] && {
		json_add_string "cid_4" "$cid_4"
		json_add_string "pdh_4" "$pdh_4"
	}
	[ -n "$pdh_6" ] && {
		json_add_string "cid_6" "$cid_6"
		json_add_string "pdh_6" "$pdh_6"
	}
	proto_close_data
	proto_send_update "$interface"

	local zone="$(fw3 -q network "$interface" 2>/dev/null)"

	[ -n "$pdh_6" ] && {
		if [ -z "$dhcpv6" -o "$dhcpv6" = 0 ]; then
			json_load "$(uqmi -s -d $device --set-client-id wds,$cid_6 --get-current-settings)"
			json_select ipv6
			json_get_var ip_6 ip
			json_get_var gateway_6 gateway
			json_get_var dns1_6 dns1
			json_get_var dns2_6 dns2
			json_get_var ip_prefix_length ip-prefix-length

			proto_init_update "$ifname" 1
			proto_set_keep 1
			proto_add_ipv6_address "$ip_6" "128"
			proto_add_ipv6_prefix "${ip_6}/${ip_prefix_length}"
			proto_add_ipv6_route "$gateway_6" "128"
			[ "$defaultroute" = 0 ] || proto_add_ipv6_route "::0" 0 "$gateway_6" "" "" "${ip_6}/${ip_prefix_length}"
			[ "$peerdns" = 0 ] || {
				proto_add_dns_server "$dns1_6"
				proto_add_dns_server "$dns2_6"
			}
			[ -n "$zone" ] && {
				proto_add_data
				json_add_string zone "$zone"
				proto_close_data
			}
			proto_send_update "$interface"
		else
			json_init
			json_add_string name "${interface}_6"
			json_add_string ifname "@$interface"
			json_add_string proto "dhcpv6"
			[ -n "$ip6table" ] && json_add_string ip6table "$ip6table"
			proto_add_dynamic_defaults
			# RFC 7278: Extend an IPv6 /64 Prefix to LAN
			json_add_string extendprefix 1
			[ -n "$zone" ] && json_add_string zone "$zone"
			json_close_object
			ubus call network add_dynamic "$(json_dump)"
		fi
	}

	[ -n "$pdh_4" ] && {
		json_init
		json_add_string name "${interface}_4"
		json_add_string ifname "@$interface"
		json_add_string proto "dhcp"
		[ -n "$ip4table" ] && json_add_string ip4table "$ip4table"
		proto_add_dynamic_defaults
		[ -n "$zone" ] && json_add_string zone "$zone"
		json_close_object
		ubus call network add_dynamic "$(json_dump)"
	}
}

qmi_wds_stop() {
	local cid="$1"
	local pdh="$2"

	[ -n "$cid" ] || return

	uqmi -s -d "$device" --set-client-id wds,"$cid" \
		--stop-network 0xffffffff \
		--autoconnect > /dev/null 2>&1

	[ -n "$pdh" ] && {
		uqmi -s -d "$device" --set-client-id wds,"$cid" \
			--stop-network "$pdh" > /dev/null 2>&1
	}

	uqmi -s -d "$device" --set-client-id wds,"$cid" \
		--release-client-id wds > /dev/null 2>&1
}

proto_qmi_teardown() {
	local interface="$1"

	local device cid_4 pdh_4 cid_6 pdh_6
	json_get_vars device

	[ -n "$ctl_device" ] && device=$ctl_device

	echo "Stopping network $interface"
#echo "Values obtained by json_get_vars:"
    echo "ctl_device: $ctl_device"    
    echo "device: $device"
	json_load "$(ubus call network.interface.$interface status)"
	json_select data
	json_get_vars cid_4 pdh_4 cid_6 pdh_6
    echo "cid_4: $cid_4"
    echo "pdh_4: $pdh_4"
    echo "cid_6: $cid_6"
    echo "pdh_6: $pdh_6"

	qmi_wds_stop "$cid_4" "$pdh_4"
	qmi_wds_stop "$cid_6" "$pdh_6"

	proto_init_update "*" 0
	proto_send_update "$interface"
}

[ -n "$INCLUDE_ONLY" ] || {
	add_protocol qmi
}
