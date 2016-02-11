#!/bin/sh

# Deletes ALL ezjail basejail and newjail zfs snapshots. Use with care!

for snapshot in ` zfs list -r -H -t snapshot zroot/usr/jails/basejail  | cut -f 1 `
do
  zfs destroy $snapshot
done

for snapshot in ` zfs list -r -H -t snapshot zroot/usr/jails/newjail  | cut -f 1 `
do
  zfs destroy $snapshot
done
