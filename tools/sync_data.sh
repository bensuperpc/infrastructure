#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source> <destination>"
    echo "Example: $0 admin@192.168.1.2:/mydata/backup /local/backup"
    exit 1
fi

SOURCE="${1}"
DEST="${2}"

# --bwlimit=30000 --whole-file

rsync -e "ssh -p 2222 -o Compression=no" \
  --progress --human-readable --archive --stats --verbose --acls --xattrs --stats --delete-during \
  "${SOURCE}" "${DEST}"
