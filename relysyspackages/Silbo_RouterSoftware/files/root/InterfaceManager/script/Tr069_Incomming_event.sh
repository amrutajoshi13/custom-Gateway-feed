#!/bin/sh

CONFIG_FILE="/etc/config/remote"

while true; do
inotifywait  -m -e close_write -e move_self "$CONFIG_FILE" |
    while read path action file; do
        echo "action detected" > /tmp/tr.txt
	 /root/InterfaceManager/script/TR069.sh
        # do something with the file
    done
done
