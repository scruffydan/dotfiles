#!/usr/bin/env sh
set -eu

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

# Validate input contains only valid ZFS name characters
case "$1" in
    *[!a-zA-Z0-9/_:-]*)
        echo "Error: Invalid characters in pool/dataset name"
        exit 1
        ;;
esac

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
printf "Type 'YES' (all caps) to confirm [YES/NO] "
read -r input

case $input in
    YES)
        echo ""
        echo "WARNING: Deleting all snapshots in 10 seconds. Hit Ctrl+C to cancel"
        sleep 10
        zfs list -H -o name -t snapshot -r "$1" | while IFS= read -r snap; do zfs destroy -v -- "$snap"; done
        ;;
    *)
    echo "Cowardly refusing to proceed any further!"
    exit 1
    ;;
esac
