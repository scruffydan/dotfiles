#!/bin/sh

# Deletes ALL zfs snapshots. Use with care!

echo "Are You Sure?"
read -r -p "Selecting yes will delete ALL snapshots in the zfs pool [YES/NO] " input

case $input in
	YES)
		echo "WARNING: Deleting all pool snapshots in 10 seconds. Hit ctrl+c to cancel"
		sleep 10
		zfs list -H -o name -t snapshot | xargs -n1 -t zfs destroy 
		;;
	*)
	echo "Cowardly refusing to proceed any further!"
	exit 1
	;;
esac
