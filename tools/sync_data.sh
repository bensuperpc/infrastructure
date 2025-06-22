#!/bin/bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source> <destination>"
    echo "Example: $0 admin@192.168.1.2:/mydata/backup /local/backup"
    exit 1
fi

SOURCE="${1}"
DEST="${2}"

rsync -e 'ssh -p 2222' --progress --human-readable --archive --verbose --compress --acls --xattrs --bwlimit=30000 --stats --delete-during "${SOURCE}" "${DEST}"
