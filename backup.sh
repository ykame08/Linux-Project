#!/bin/bash

BACKUP_DIR="/opt/sysmonitor/backups/"
LOG_FILE="/var/log/backup.log"
SOURCE_DIR="/home/"
DATE=$(date "+%Y_%m_%d_%H_%M_%S")

# Ensure backup directory exists
mkdir -p $BACKUP_DIR

# Calculate size and check free space
SIZE=$(du -s $SOURCE_DIR | awk '{print $1}')
FREE_SPACE=$(df $BACKUP_DIR | tail -1 | awk '{print $4}')

if [ "$SIZE" -gt "$FREE_SPACE" ]; then
    echo "[$DATE] Not enough disk space for backup" >> $LOG_FILE
    exit 1
fi

# Create backup
BACKUP_FILE="${BACKUP_DIR}${DATE}_home_backup.tar.gz"
tar -czf $BACKUP_FILE $SOURCE_DIR

# Log success
echo "[$DATE] Backup created: $BACKUP_FILE" >> $LOG_FILE

# Remove old backups
find $BACKUP_DIR -type f -mtime +7 -exec rm -f {} \;

# Interactive mode
if [[ $- == *i* ]]; then
    echo "Recent backups:"
    tail -5 $LOG_FILE
fi
