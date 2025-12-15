#!/bin/sh
set -euo pipefail

# Deletes ALL zfs snapshots. Use with care!

# Validate pool/dataset parameter
if [ -z "${1:-}" ]; then
    echo "Usage: $(basename "$0") <pool_name|dataset>"
    exit 1
fi

# Verify pool or dataset exists
if ! zfs list -H "$1" >/dev/null 2>&1; then
    echo "Error: ZFS pool or dataset '$1' does not exist"
    exit 1
fi

echo "Are You Sure?"
read -r -p "Selecting yes will delete ALL snapshots [YES/NO] " input

case $input in
    YES)
        echo "WARNING: Deleting all snapshots in 10 seconds. Hit ctrl+c to cancel"
        sleep 10
        zfs list -H -o name -t snapshot -r "$1" | xargs -n1 -t zfs destroy
        ;;
    *)
    echo "Cowardly refusing to proceed any further!"
    exit 1
    ;;
esac
