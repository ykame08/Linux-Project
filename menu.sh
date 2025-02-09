#!/bin/bash

# Ensure root permissions
if [ "$(id -u)" -ne 0 ]; then
    echo "You need to run this script as root."
    exit 1
fi

# Menu loop
while true; do
    echo "1. Display system metrics"
    echo "2. Show last 5 backup logs"
    echo "3. Perform manual backup"
    echo "4. Perform manual cleanup"
    echo "5. Show running processes count"
    echo "6. Exit"
    read -p "Choose an option: " OPTION

    case $OPTION in
        1) /usr/local/bin/monitor.sh ;;
        2) tail -5 /var/log/backup.log ;;
        3) /usr/local/bin/backup.sh ;;
        4) /usr/local/bin/cleanup.sh ;;
        5) ps aux | wc -l ;;
        6) exit 0 ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
