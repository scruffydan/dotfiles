#!/bin/sh
set -euo pipefail

# Deletes ALL ZFS snapshots recursively from the specified pool or dataset
# Examples:
#   - Pool: 'tank' deletes ALL snapshots in the entire pool
#   - Dataset: 'tank/data/home' deletes snapshots for that dataset and all children
# Use with extreme care!

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

# Count snapshots to be deleted
snapshot_count=$(zfs list -H -o name -t snapshot -r "$1" 2>/dev/null | wc -l | tr -d ' ')

echo "Target: $1"
echo "Snapshots found (recursive): $snapshot_count"
echo ""
echo "WARNING: This will delete ALL $snapshot_count snapshots for '$1' and its children"
echo "Are You Sure?"
read -r -p "Type 'YES' (all caps) to confirm [YES/NO] " input

case $input in
    YES)
        echo ""
        echo "WARNING: Deleting all snapshots in 10 seconds. Hit Ctrl+C to cancel"
        sleep 10
        zfs list -H -o name -t snapshot -r "$1" | xargs -n1 -t zfs destroy
        ;;
    *)
    echo "Cowardly refusing to proceed any further!"
    exit 1
    ;;
esac
