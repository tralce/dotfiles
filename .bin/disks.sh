#!/bin/bash
# vim:fdm=marker

# variables, sources {{{
source ~/.bin/src.sh
image=
disk=
fs="ntfs"
label=
disks_stopped=no
# }}}

helpmsg() { # {{{
  echo "$(basename $0) [-d disk] [-i iso] [-f fs] [-l label] [-h]"
  echo '-d disk  ("-d /dev/sda")'
  echo '-i iso   ("-i arch.iso")'
  echo '-f fs    ("-f btrfs   ")'
  echo '-l label ("-l my_usb  ")'
  echo '-h       ( help        )'
} # }}}

while getopts "d:i:f:l:h" arg # {{{
do
  case ${arg} in
    i)  image="${OPTARG}";;
    d)  disk="${OPTARG}";;
    f)  fs="${OPTARG}";;
    l)  label="${OPTARG}";;
    h)  helpmsg;;
  esac
done
shift $(( OPTIND - 1 )) # }}}

terminate() { # {{{
  if [ ${disks_stopped} = "yes" ]
  then
    echocolor yellow "Starting disks.service"
    systemctl --user start disks.service
  fi
  exit ${1}
} # }}}

fail() { # {{{
  case "${1}" in
    1)  exitstring="You must specify exactly one disk as an argument";;
    2)  exitstring="pv not installed";;
    3)  exitstring="There was an issue unmounting ${disk}";;
    4)  exitstring="Something went wrong with wipefs";;
    5)  exitstring="parted failed creating a GPT";;
    6)  exitstring="Something went wrong while copying";;
    7)  exitstring="parted failed creating a partition";;
    9)  exitstring="User did not press y or something else happened";;
    8)  exitstring="${disk} is not a block device";;
    10) exitstring="Failed creating a filesystem";;
    11) exitstring="${fs} is not a supported filesystem";;
  esac
  echocolor red "${exitstring} -- Exiting."
  terminate ${1}
} # }}}

stopdisks() { # {{{
  if systemctl --user is-active disks.service &> /dev/null
  then
    echocolor yellow "Stopping disks.service"
    systemctl --user stop disks.service
    disks_stopped="yes"
    sleep 1
  fi
} # }}}

umnt() { # {{{
  if grep -q "${disk}" /etc/mtab
  then
    checkroot umount ${disk}*
    sleep 1
  fi
} # }}}

command -v pv &> /dev/null || fail 2

if [ -n "${disk}" ]
then
  if [ -b "${disk}" ]
  then
    if [ -z ${image} ]
    then
      # erase disk # {{{
      if [ -z "${label}" ]
      then
        echocolor yellow "Guessing a label..."
        label="$(checkroot smartctl -i ${disk}|grep Capacity|sed -e 's/.*bytes \[\(.*\)\].*/\1/' -e 's/ //g')"
        [ -z "${label}" ] && label="$(lsblk -o SIZE ${disk}|grep -v SIZE|head -n 1|sed -e 's/^ *//g' -e 's/ //g')"
      fi
      read -p "About to demolish ${disk} (${label})... Confirm: (y/n) " -n 1 choice
      echo
      if [ ${choice,,} = "y" ]
      then
        stopdisks
        umnt
        echocolor yellow "Disk is ${disk}, partition will be ${disk}1"
        echocolor yellow "Label will be ${label}"
        echocolor yellow "Wiping all existing filesystems..."
        checkroot wipefs --all ${disk} &>/dev/null || fail 4
        echocolor yellow "Creating GPT..."
        checkroot parted ${disk} mklabel GPT || fail 5
        echocolor yellow "Creating partition..."
        checkroot parted ${disk} mkpart primary 0% 100% || fail 7
        sleep 2
        echocolor yellow "Formatting with ${fs}..."
        case ${fs} in
          btrfs)  checkroot mkfs.btrfs -f -L "${label}" ${disk}1 || fail 10;;
          ext4)   checkroot mkfs.ext4 -L "${label}" ${disk}1 || fail 10;;
          ntfs)   checkroot mkfs.ntfs --fast --label "${label}" ${disk}1 || fail 10;;
          vfat)   checkroot mkfs.vfat -n "${label}" ${disk}1 || fail 10;;
          fat12)  checkroot mkfs.vfat -n "$(echo "${label}"|sed -e 's/\./_/g')" -F 12 ${disk}1 || fail 10;;
          fat16)  checkroot mkfs.vfat -n "$(echo "${label}"|sed -e 's/\./_/g')" -F 16 ${disk}1 || fail 10;;
          fat32)  checkroot mkfs.vfat -n "$(echo "${label}"|sed -e 's/\./_/g')" -F 32 ${disk}1 || fail 10;;
          *)    fail 11;;
        esac
        echocolor yellow "Disk info:"
        badsect.sh "${disk}"
        terminate 0
      fi
      # }}}
    else
      # copy image {{{
      echocolor cyan "Input:  ${image}"
      echocolor cyan "Output: ${disk}"
      read -p "Punch it? (y/n) " -n 1 choice
      echo
      if [ "${choice,,}" = "y" ]
      then
        stopdisks
        umnt
        if pv "${image}" | checkroot dd bs=1M conv=fdatasync oflag=sync of=${disk}
        then
          sync
          echocolor green "Success!"
          terminate 0
        else
          fail 6
        fi
      fi
      # }}}
    fi
  else
    fail 8
  fi
else
  fail 1
fi
