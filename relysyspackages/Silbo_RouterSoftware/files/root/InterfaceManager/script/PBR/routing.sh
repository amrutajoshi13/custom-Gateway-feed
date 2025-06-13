#!/bin/sh

. /lib/functions.sh

Routing_Config="/etc/config/routingconfig"

##ipcal_Script inbuild Openwrt script ##
ipcal="/rom/bin/ipcalc.sh"

##Delete the older Commands.##
del="/root/InterfaceManager/script/routing/PBR/delete.sh"
chmod 700 $del

#Run the "/tmp/delete.sh" Script initially.
DEL=$($del)

ReadRoutingConfig() {
    config_load "$Routing_Config"
    config_foreach Advanced_Custom_Rules rule
    config_foreach Static_RoutingConfig routes
    # config_foreach Advanced_Routes_For_Table route
}

Static_RoutingConfig() {

    # #### Syntax of ip route add command ####
    # ip route add $Static_Network_prefix via $Gateway dev $iface table main metric $Metric

    local RoutingConfigSection="$1"
    config_get iface "$RoutingConfigSection" interface
    config_get destination "$RoutingConfigSection" target
    config_get Genmask "$RoutingConfigSection" ipv4netmask
    config_get Metric "$RoutingConfigSection" metric
    config_get Gateway "$RoutingConfigSection" ipv4gateway
    config_get Routetype "$RoutingConfigSection" routetype
    config_get Tableid "$RoutingConfigSection" tableid

    var=$($ipcal $destination $Genmask)
    Static_Network_prefix=$(echo \"$var\  | awk -F' |=' '/NETWORK=/{network=$2} /PREFIX=/{prefix=$10} END{print network "/" prefix}')

    # Set table option
    [ "$Tableid" = "table main" ] && table_option="" || table_option="table $Tableid"

    # Set route type variables
    [ -n "$Static_Network_prefix" ] && var_prefix="$Static_Network_prefix" || var_prefix=""
    [ -n "$Gateway" ] && var_gateway="via $Gateway" || var_gateway=""
    [ -n "$iface" ] && var_iface="dev $iface" || var_iface=""
    [ -n "$Metric" ] && var_metric="metric $Metric" || var_metric=""

    # Handle route types using case statement
    case "$Routetype" in
    unicast)
        ip route add $var_prefix $var_gateway $var_iface $table_option $var_metric &&
            echo "ip route delete $var_prefix $var_gateway $var_iface $table_option $var_metric"
        ;;
    blackhole | prohibit | unreachable | throw)
        ip route add $Routetype $var_prefix $table_option &&
            echo "ip route delete $Routetype $var_prefix $table_option"
        ;;
    broadcast | multicast)
        ip route add $Routetype $var_prefix $var_gateway $var_iface &&
            echo "ip route delete $Routetype $var_prefix $var_gateway $var_iface"
        ;;
    esac
}

Advanced_Custom_Rules() {
    local RoutingConfigSection="$1"
    config_get ruletype "$RoutingConfigSection" ruletype
    config_get To "$RoutingConfigSection" to
    config_get From "$RoutingConfigSection" from
    config_get Netmask "$RoutingConfigSection" ipv4netmask
    config_get Table "$RoutingConfigSection" table
    config_get Priority "$RoutingConfigSection" priority
    config_get enable_iif "$RoutingConfigSection" enable_iif
    config_get interface_iif "$RoutingConfigSection" interface_iif
    config_get enable_oif "$RoutingConfigSection" enable_oif
    config_get interface_oif "$RoutingConfigSection" interface_oif
    config_get enable_fwmark "$RoutingConfigSection" enable_fwmark
    config_get Hex_fwmark "$RoutingConfigSection" Hex_fwmark

    var_custom_rules=$($ipcal $To $Netmask)

    Advanced_Static_Network_prefix=$(echo \"$var_custom_rules\  | awk -F' |=' '/NETWORK=/{network=$2} /PREFIX=/{prefix=$10} END{print network "/" prefix}')

    var_iif=""
    var_oif=""
    var_fwmark=""


    #IPV4 address
    [ -n "$Advanced_Static_Network_prefix" ] && var_to="to $Advanced_Static_Network_prefix" || var_to=""

    [ -n "$From" ] && var_from="from $From" || var_from=""

    [ -n "$Priority" ] && var_priority="priority $Priority" || var_priority=""

    [ -n "$Table" ] && var_table="table $Table" || var_table=""

    if [ "$enable_iif" = "1" ]; then
        [ -n "$interface_iif" ] && var_iif="iif $interface_iif" || var_iif=""
    fi

    if [ "$enable_oif" = "1" ]; then
        [ -n "$interface_oif" ] && var_oif="oif $interface_oif" || var_oif=""
    fi
    if [ "$enable_fwmark" = "1" ]; then
        [ -n "$Hex_fwmark" ] && var_fwmark="fwmark $Hex_fwmark" || var_fwmark=""
    fi

    if [ "$ruletype" = "lookup" ]; then
        ruletype=""
    fi

    ip rule add $ruletype $var_from $var_to $var_table $var_priority $var_iif $var_oif $var_fwmark
    #ip rule add to $Advanced_Static_Network_prefix from $From table $Table priority $Priority

    echo ip rule del $ruletype $var_from $var_to $var_table $var_priority $var_iif $var_oif $var_fwmark

}

ReadRoutingConfig >/root/InterfaceManager/script/routing/PBR/delete.sh
