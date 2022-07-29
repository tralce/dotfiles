#!/bin/bash
# vim: fdm=marker
# bad sector check 2020-02-16
# uses awk etc to extract actually useful information from smartctl -a
# depends on sudo, awk, column, smartmontools

if [ -f ~/Scripts/src/src.sh ] # {{{
then
  source ~/Scripts/src/src.sh
else
  echocolor() {
    color="$1"
    shift 1
    case $color in
      black|0)        echo -e "\033[30m$*\033[0m";;
      red|1)          echo -e "\033[31m$*\033[0m";;
      green|2)        echo -e "\033[32m$*\033[0m";;
      yellow|3)       echo -e "\033[33m$*\033[0m";;
      blue|4)         echo -e "\033[34m$*\033[0m";;
      magenta|5)      echo -e "\033[35m$*\033[0m";;
      cyan|6)         echo -e "\033[36m$*\033[0m";;
      white|7)        echo -e "\033[37m$*\033[0m";;
      *)              echo -e "$*";;
    esac
  }
  checkroot() {
    if [ "$UID" -eq "0" ]
    then
      $*
    else
      sudo $*
    fi
  }
fi # }}}

if [ $# -eq 0 ]
then
  echo "$(basename "$0") /dev/sdx [ /dev/sdy /dev/sdz ... ]"
  exit 1
fi

for disk in "$@"
do
  echo -e "$disk"
  tmp=$(mktemp)
  checkroot smartctl -a "$disk" | grep 'Device Model\|User Capacity'
  checkroot smartctl -a "$disk" | grep 'ATTRIBUTE_NAME\|Reallocated_Sector_Ct\|Reallocated_Event_Count\|Current_Pending_Sector\|Offline_Uncorrectable\|Spin_Retry_Count\|Power_On_Hours\|Wear\|Fail\|Power_Cycle_Count\|_Error\|Total_LBAs_Written' | awk '{print $2,",",$10,",",$4,",",$5,",",$6,",",$7}' | column -ts,
  checkroot smartctl -l error "$disk" > $tmp
  if grep "Error Count" $tmp 2> /dev/null
  then
    echocolor red "DISK ERRORS PRESENT - check smartctl -l error $disk"
  elif grep "No Errors Logged" $tmp &> /dev/null
  then
    echocolor green "Disk is free of errors in SMART error log."
  else
    echocolor cyan "Disk doesn't seem to support SMART error logging"
  fi
  rm $tmp
done

