#!/bin/bash

# Set the threshold percentage (e.g., 90%)
THRESHOLD=80

# Specify the mount point you want to monitor | Dpac: to get the mount point run df -h in terminal
MOUNT_POINT="/System/Volumes/Data"

# Specify the Slack webhook URL
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/your/webhook/id"

# Get the disk usage details
DISK_DETAILS=$(df -hP "$MOUNT_POINT" | grep -vE '^Filesystem|tmpfs')
USED_SPACE=$(echo "$DISK_DETAILS" | awk '{ print $3 }')
TOTAL_SPACE=$(echo "$DISK_DETAILS" | awk '{ print $2 }')
DISK_USAGE=$(echo "$DISK_DETAILS" | awk '{ print $5 }' | sed 's/%//g')

# Echo the disk usage details
echo "Used space: $USED_SPACE"
echo "Total space: $TOTAL_SPACE"
echo "Percentage of used space: $DISK_USAGE%"

# Check if disk usage is greater than or equal to the threshold
if [ "$DISK_USAGE" -ge "$THRESHOLD" ]; then
    # Prepare the JSON payload for the Slack webhook
    PAYLOAD='{"text": "Shared Server disk size is at '"$DISK_USAGE"'%!\nUsed space: '"$USED_SPACE"',\nTotal space: '"$TOTAL_SPACE"', \n "}'

    # Send a curl request to the Slack webhook URL
    curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$SLACK_WEBHOOK_URL"
fi
