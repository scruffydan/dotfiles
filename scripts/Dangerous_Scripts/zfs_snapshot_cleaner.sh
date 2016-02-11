#!/bin/sh

# Deletes ALL zfs snapshots. Use with care!

for snapshot in `zfs list -H -t snapshot | cut -f 1 | grep zroot`
do
  zfs destroy $snapshot
done
