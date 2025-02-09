#!/bin/bash

DIRS=("/tmp" "/var/tmp" "/var/log")
DAYS=17
LOG_FILE="/var/log/cleanup.log"

# Check if user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "You need to run this script as root."
    exit 1
fi

# Clean up files
for DIR in "${DIRS[@]}"; do
    find $DIR -type f -mtime +$DAYS -exec rm -f {} \;
done

# Interactive mode
if [[ $- == *i* ]]; then
    TOTAL_SIZE=$(du -sh "${DIRS[@]}" | awk '{total += $1} END {print total}')
    if (( $(echo "$TOTAL_SIZE > 10" | bc -l) )); then
        echo "The total size of files to be deleted is $TOTAL_SIZE MiB. Proceed? [y/n]"
        read -r RESPONSE
        if [[ "$RESPONSE" == "y" ]]; then
            find $DIR -type f -mtime +$DAYS -exec rm -f {} \;
        else
            echo "Cleanup aborted."
        fi
    fi
fi
