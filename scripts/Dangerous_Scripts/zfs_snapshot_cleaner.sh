#!/bin/sh

# Deletes ALL zfs snapshots. Use with care!

echo "Are You Sure?"
read -r -p "Selecting yes will delete ALL snapshots [YES/NO] " input

case $input in
    YES)
        echo "WARNING: Deleting all snapshots in 10 seconds. Hit ctrl+c to cancel"
        sleep 10
        zfs list -H -o name -t snapshot -r $1 | xargs -n1 -t zfs destroy 
        ;;
    *)
    echo "Cowardly refusing to proceed any further!"
    exit 1
    ;;
esac
