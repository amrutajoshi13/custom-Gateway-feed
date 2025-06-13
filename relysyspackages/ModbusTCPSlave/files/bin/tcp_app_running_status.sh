#!/bin/bash

APP_NAME="TCP_Slave_Utility_project"
PID=$(pgrep -f "$APP_NAME" | head -n 1)
LOGFILE="/var/log/tcp_app_events.log"
LAST_START_FILE="/tmp/.tcp_last_start"
LAST_STATE_FILE="/tmp/.tcp_last_state"  # can be "running" or "stopped"

TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

# If app is NOT running
if [ -z "$PID" ]; then
    LAST_STATE=$(cat "$LAST_STATE_FILE" 2>/dev/null)
    if [ "$LAST_STATE" != "stopped" ]; then
        echo "$TIMESTAMP App STOPPED" >> "$LOGFILE"
        echo "stopped" > "$LAST_STATE_FILE"
    fi
    exit 1
fi

# App is running
echo "running" > "$LAST_STATE_FILE"

CURRENT_START=$(ps -p "$PID" -o lstart=)
LAST_START=$(cat "$LAST_START_FILE" 2>/dev/null)

if [ "$CURRENT_START" != "$LAST_START" ]; then
    if [ -n "$LAST_START" ]; then
        echo "$TIMESTAMP App RESTARTED" >> "$LOGFILE"
        echo "$TIMESTAMP️  Previous Start: $LAST_START" >> "$LOGFILE"
    else
        echo "$TIMESTAMP App STARTED" >> "$LOGFILE"
    fi
    echo "$CURRENT_START" > "$LAST_START_FILE"
    echo "$TIMESTAMP Current Start : $CURRENT_START" >> "$LOGFILE"
fi
