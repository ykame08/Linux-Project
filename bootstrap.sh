#!/bin/bash

# Check if the user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "You need to run this script as root."
    exit 1
fi

# Copy scripts to /usr/local/bin/
cp menu.sh monitor.sh backup.sh cleanup.sh /usr/local/bin/

# Create crontab entries
(crontab -l 2>/dev/null; echo "0 * * * * /usr/local/bin/monitor.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 4,20 * * * /usr/local/bin/backup.sh") | crontab -
(crontab -l 2>/dev/null; echo "0 0 1 * * /usr/local/bin/cleanup.sh") | crontab -

echo "Scripts installed and scheduled successfully."
