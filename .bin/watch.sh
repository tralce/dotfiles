#!/bin/bash

trap exit INT

delay="1"

while getopts "d:" arg
do
  case $arg in
    d) delay="$OPTARG";;
    *) echo "Bad args";exit 1
  esac
done

shift $(( OPTIND - 1 ))

while true
do
  clear
  echo "Every ${delay}s - $@"
  $@
  sleep $delay
done
