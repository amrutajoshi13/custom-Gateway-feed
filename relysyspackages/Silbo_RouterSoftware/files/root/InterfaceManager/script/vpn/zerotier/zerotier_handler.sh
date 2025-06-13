#!/bin/sh

. /lib/functions.sh

zerotirestop="/etc/init.d/zerotier stop"

zerotirestart="/etc/init.d/zerotier start"

Enablezerotire=$(uci get vpnconfig1.general.enablezerotiergeneral)
       wanCount=$(cat /etc/waninterface.txt | wc -l)
       lanCount=$(cat /etc/internetoverlan.txt | wc -l)

if [ "$Enablezerotire" = "1" ]; then
       response=$($zerotirestart)

       #Firewall
       #All the VPN features are working with single ZONE
       uci set firewall.zerotier=zone
       uci set firewall.zerotier.name="zerotier"
       uci set firewall.zerotier.input="ACCEPT"
       uci set firewall.zerotier.output="ACCEPT"
       uci set firewall.zerotier.forward="ACCEPT"
       uci set firewall.zerotier.device="zt+"
       uci set firewall.zerotier.masq="1"
       uci set firewall.zerotier.mtu_fix="1"

       for j in $(seq 1 ${wanCount}); do

              wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)

              #Creating the firewall Forwarding ZONE

              uci set firewall.${wan}zerotier="forwarding"
              uci set firewall.${wan}zerotier.src="Sample"
              uci set firewall.${wan}zerotier.dest=${wan}

              uci set firewall.zerotier${wan}="forwarding"
              uci set firewall.zerotier${wan}.src=${wan}
              uci set firewall.zerotier${wan}.dest="Sample"
       done
       
       for j in $(seq 1 ${lanCount}); do
              lan=$(cat /etc/internetoverlan.txt | head -${j} | tail -1)

              uci set firewall.${lan}zerotier="forwarding"
              uci set firewall.${lan}zerotier.src=${lan}
              uci set firewall.${lan}zerotier.dest="Sample"

              uci set firewall.zerotier${lan}="forwarding"
              uci set firewall.zerotier${lan}.src="Sample"
              uci set firewall.zerotier${lan}.dest=${lan}

       done
else
       response=$($zerotirestop)
       for j in $(seq 1 ${wanCount}); do

              wan=$(cat /etc/waninterface.txt | head -${j} | tail -1)
              uci delete firewall.zerotier${wan}
              uci delete firewall.${wan}zerotier

       done

       for j in $(seq 1 ${lanCount}); do

              lan=$(cat /etc/internetoverlan.txt | head -${j} | tail -1)
              uci delete firewall.zerotier${lan}
              uci delete firewall.${lan}zerotier

       done
fi

uci commit firewall
