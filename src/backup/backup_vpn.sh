#!/bin/bash
# backup directory
BACKUP_DIR="/var/backups/vpn"
DATA_TO_BACKUP="/etc/openvpn"

# file name with date
FILENAME="vpn_backup_$(date +%Y-%m-%d_%H%M%S).tar.gz"

# make tar
sudo tar -czf "$BACKUP_DIR/$FILENAME" $DATA_TO_BACKUP 2>/dev/null

# checking successfully
if [ $? -eq 0 ]; then
    # Make "success flag" — file, which time Prometheus check
    touch "$BACKUP_DIR/backup_success.flag"
    echo "Backup made successfully: $FILENAME"
else
    echo "Error making backup!"
    exit 1
fi

# Delete > 14 days
find "$BACKUP_DIR" -name "vpn_backup_*.tar.gz" -mtime +14 -exec rm {} \;

