#!/bin/sh

. /lib/functions.sh

OpenvpnUCIPath=/etc/config/openvpn

EnableOpenvpn=$(uci get vpnconfig1.general.enableopenvpngeneral)

##Delete wireguard names for Client from the network file.###
Bridge="/root/InterfaceManager/script/vpn/openvpn/bridge.sh"
chmod 700 /root/InterfaceManager/script/vpn/openvpn/bridge.sh

#Run the "/root/InterfaceManager/script/vpn/wireguard/ucidelete2.sh" which deletes the names from the network file.
var = $($Bridge)

#Delete the ucidelete2.sh and then create a new one for every update button pressed.
rm /root/InterfaceManager/script/vpn/openvpn/bridge.sh

ReadOpenvpnUCIConfig() {
    config_load "$OpenvpnUCIPath"
    config_foreach OpenvpnConfigParameters openvpn1
}

OpenvpnConfigParameters() {
    local OpenvpnConfigSection="$1"
    config_get Name "$OpenvpnConfigSection" name
    config_get Enable "$OpenvpnConfigSection" enable
    config_get Mode "$OpenvpnConfigSection" mode
    config_get Bridge "$OpenvpnConfigSection" bridge
    config_get Interface "$OpenvpnConfigSection" interface

    #Check the generalopenvpn && Opnvpn Enable
    if [ "$Enable" = "1" ] && [ "$EnableOpenvpn" = "1" ]; then

        if [ "$Mode" = "TUN" ]; then

            if [ "$Bridge" == "1" ]; then
                uci set openvpn.$Name.bridge="0"
                uci commit openvpn
            fi
        fi

        if [ "$Mode" = "TAP" ]; then

            if [ "$Bridge" == "1" ]; then

                uci set network.$Interface.type='bridge'

                #Get Bridge.sh File
                echo uci delete network.$Interface.type

                uci commit network

                echo uci commit network

                /etc/init.d/network restart                                                             
                            

                # restart the SW_LAN
                #ubus call network reload '{"config": '$Interface', "apply": true}'

                #Get restart the SW_LAN Bridge.sh File
                #echo ubus call network reload '{"config": '$Interface', "apply": true}'

            else
                uci delete network.$Interface.type

                uci commit network
                
                #restart the SW_LAN
                #ubus call network reload '{"config": '$Interface', "apply": true}'
            fi
        fi
    else
        uci delete network.$Interface.type
        uci commit network

        # restart the SW_LAN
        #ubus call network reload '{"config": '$Interface', "apply": true}'
    fi

}

ReadOpenvpnUCIConfig >>/root/InterfaceManager/script/vpn/openvpn/bridge.sh

