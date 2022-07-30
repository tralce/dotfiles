#!/bin/bash
# vim: fdm=marker
# bad sector check 2020-02-16
# uses awk etc to extract actually useful information from smartctl -a
# depends on sudo, awk, column, smartmontools

source ~/bin/src.sh

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

