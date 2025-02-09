#!/bin/bash

LOG_FILE="/var/log/monitor.log"

# Check if user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "You need to run this script as root."
    exit 1
fi

# Collect metrics
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
RX=$(cat /sys/class/net/ens33/statistics/rx_bytes)
TX=$(cat /sys/class/net/ens33/statistics/tx_bytes)
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# Write to log
echo "[$DATE] $CPU% $MEM% $TX $RX" >> $LOG_FILE

# Interactive mode
if [[ $- == *i* ]]; then
    LAST_LINE=$(tail -1 $LOG_FILE 2>/dev/null)
    echo "Current system metrics:"
    echo "CPU usage: $CPU%"
    echo "Memory usage: $MEM%"
    echo "Tx/Rx bytes: $TX/$RX"
    echo "Last log entry: $LAST_LINE"
fi
