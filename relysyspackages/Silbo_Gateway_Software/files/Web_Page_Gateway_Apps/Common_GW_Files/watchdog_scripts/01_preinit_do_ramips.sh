#!/bin/sh

do_ramips() {
	. /lib/ramips.sh
	Second_sim_default=$(hexdump -v -n 1 -s 0x140 -e '7/1 "%01X:" 1/1 "%01X"' /dev/mtd2 | sed 's/://g')
     Second_sim_default=$(echo "$Second_sim_default" | tr -d '\013\014\015 ')
		if [ "$Second_sim_default" = "58" ] ;then
			echo 1 > /sys/class/gpio/export
			echo out > /sys/class/gpio/gpio2/direction
			echo 1 > /sys/class/gpio/gpio2/value
			sleep 2
		fi
				
	ramips_board_detect
}

boot_hook_add preinit_main do_ramips
