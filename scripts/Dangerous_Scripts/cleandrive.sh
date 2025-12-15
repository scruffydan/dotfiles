#!/bin/sh

if [ -z "$1" ]; then
  echo "Usage: $(basename $0) drive1 drive2 ..."
  exit 1
fi

drives="$*"

verifydrives() {
  for drive in $drives; do
    if [ "$(ls -l /dev/ | grep -w "$drive" | wc -l)" = "0" ]; then
      echo "Drive $drive does not exist. Aborting."
      exit 1
    else
      echo "Drive $drive verified."
    fi
  done
}

seeksector() {
  blocksize=$(dmesg | grep -w "$drive" | grep -oe '[0-9]\{7,\}')
  mbsize=$(echo "$blocksize / 2048" | bc)
  echo "$mbsize - 10" | bc
}

cleandrives() {
  for drive in $drives; do
    dd if=/dev/zero of=/dev/"$drive" bs=1M count=10 >/dev/null 2>&1
    dd if=/dev/zero of=/dev/"$drive" bs=1M count=10 seek="$(seeksector "$drive")" >/dev/null 2>&1
  done
}

verifydrives "$drives"

echo ""
echo "This will irreversibly destroy partition- and filesystem data on drive(s):"
echo "$drives"
echo ""
echo "USE WITH EXTREME CAUTION!"
read -r -p 'Do you confirm "yes/no": ' choice
case "$choice" in
  yes)
    cleandrives "$drives"
    echo ""
    echo "Drive(s) cleaned."
    ;;
  no)
    echo ""
    echo "Cleaning cancelled."
    ;;
  *)
    echo ""
    echo "Cleaning cancelled."
    ;;
esac
