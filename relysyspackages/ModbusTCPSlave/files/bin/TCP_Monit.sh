#!/bin/bash

# Define the process name and path
PROCESS_NAME="TCP_Slave_Utility_project"
PROCESS_PATH="/root/TCPSLAVE/TCP_Slave_Utility_project"
EnableTCP=$(uci get tcpconfig.tcpconfig.enabletcp)
# Check if the process is running and kill it


if [ $EnableTCP == 1]
then

if ps x | grep -i "$PROCESS_NAME" | grep -v grep > /dev/null; then
    echo "Stopping $PROCESS_NAME..."
    pkill -x "$PROCESS_NAME"
    sleep 2
fi

# Restart the application
echo "Starting $PROCESS_NAME..."
nohup "$PROCESS_PATH" > /dev/null 2>&1 &

# Verify if the process started successfully
sleep 1
if pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "$PROCESS_NAME restarted successfully."
else
    echo "Failed to restart $PROCESS_NAME."
    exit 1
fi


fi
