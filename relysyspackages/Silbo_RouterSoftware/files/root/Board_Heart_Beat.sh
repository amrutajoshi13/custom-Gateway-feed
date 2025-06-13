#!/bin/sh

enable_ID=$(uci get cloudconfigNH.cloudconfigNH.enablenwh)
server=$(uci get cloudconfigNH.cloudconfigNH.HTTPServerURL)
if [ "$enable_ID" == "1" ] && [ "$server" == "url" ]; then

    Device_id=$(uci get boardconfig.board.serialnum)
    tunip=$(ifconfig tun0 | grep -oE 'inet addr:[0-9.]+' | grep -oE '[0-9.]+')
    if [ -n "$tunip" ]; then
        PacketLoss=$(ping -c 5 $tunip | grep "packet loss" | cut -d "," -f 3 | tr -d " " | cut -d "%" -f 1)
        if [ "$PacketLoss" -eq 0 ]; then
            vpnstatus="Active"
        else
            vpnstatus="Inactive"
        fi
    else
        vpnstatus="Inactive"
        tunip="NA"
    fi
    

    data=$(
        cat <<EOF
{
    "Device_ID": "$Device_id",
    "VPN_STATUS": "$vpnstatus",
    "TUN_IP": "$tunip"
}
EOF
    )
    echo "$data"
    max_attempts=5
    attempts=0

    while [ $attempts -lt $max_attempts ]; do
        if
            ping -c 1 -W 2 "45.118.163.97" &
            >/dev/null
        then
            echo "Server is reachable. Sending data..."
            curl -k --request POST \
                --url https://139.59.65.241/api/device-heartbeat/ \
                --header "Content-Type: application/json" \
                --data "$data"

            # curl --data "$data" -v http://10.1.1.174/api/device-data/
            break # exit the loop once data is sent
        else
            echo "Server is not reachable. Retrying in 10 seconds (attempt $((attempts + 1)) of $max_attempts)..."
            sleep 10
            attempts=$((attempts + 1))
        fi
    done

    if [ $attempts -eq $max_attempts ]; then
        echo "Failed to send data after $max_attempts attempts. Exiting with an error."
    fi

else
    echo "server not enable"
fi
