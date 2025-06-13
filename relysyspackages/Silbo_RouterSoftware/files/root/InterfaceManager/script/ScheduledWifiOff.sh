#!/bin/sh
 . /lib/functions.sh

uci set sysconfig.wificonfig.wifi1enable='0'
uci commit sysconfig

uci set sysconfig.guestwifi.guestwifienable='0'
uci commit sysconfig

sleep 1
/bin/UpdateWanConfig.sh
