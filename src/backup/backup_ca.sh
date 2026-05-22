#!/bin/bash
# CA backup
BACKUP_DIR="/var/backups/ca"
DATA_TO_BACKUP="/home/yc-user/easy-rsa"

# Form file name
FILENAME="ca_backup_$(date +%Y-%m-%d_%H%M%S).tar.gz"

# Make archive with keys and base 
tar -czf "$BACKUP_DIR/$FILENAME" -C /home/yc-user easy-rsa 2>/dev/null

# check success
if [ $? -eq 0 ]; then
    touch "$BACKUP_DIR/backup_success.flag"
    echo "CA backup made successfully: $FILENAME"
else
    echo "Error wile making CA backup!"
    exit 1
fi

# Delete CA arcive older than 14 days
find "$BACKUP_DIR" -name "ca_backup_*.tar.gz" -mtime +14 -exec rm {} \;

