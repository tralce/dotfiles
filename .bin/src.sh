#!/bin/bash

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

