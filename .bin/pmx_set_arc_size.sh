#!/bin/bash

conf="/etc/modprobe.d/zfs.conf"
const=1048576

fail() {
  echo "$*"
  exit 1
}

command -v zpool &> /dev/null || fail "does not have zfs"
command -v bc &> /dev/null || fail "does not have bc"
[ -z $1 ] && fail "must specify arc size in mb as only arg"
[ -f "${conf}" ] && mv ${conf} ${conf}.bak

max="$(echo "${1}*${const}" | bc)"
min="$(echo "(${1}*${const})/2" | bc)"

echo "max: $max"
echo "min: $min"

echo "options zfs zfs_arc_max=${max}" >> /etc/modprobe.d/zfs.conf
echo "options zfs zfs_arc_min=${min}" >> /etc/modprobe.d/zfs.conf

echo ${max} >> /sys/module/zfs/parameters/zfs_arc_max
echo ${min} >> /sys/module/zfs/parameters/zfs_arc_min

update-initramfs -u
