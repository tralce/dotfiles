#!/bin/bash
# script to show sizes of trash dirs, which should have been part of trash-cli
# 2020-01-09

shopt -s nullglob

trashdirlist="$HOME/.local/share/Trash/files $HOME/*/.Trash-*/files /media/*/.Trash-*/files ~/.Trash /Volumes/*/.Trash-* /storage/.Trash/*/files"

totals() {
  du -hs --total $trashdirlist 2>/dev/null
}

if [ $# -eq 0 ]
then
  totals
fi

while getopts "vs" arg
do
  case "$arg" in
    v)      for trashdir in $trashdirlist
    do
      if [ -d "$trashdir" ]
      then
        if pushd "$trashdir" 2> /dev/null
        then
          du -hs * | sort -rh | head -n 10
          popd &> /dev/null
        else
          echo "Couldn't \"pushd $trashdir\" for some reason"
        fi
        echo
      fi
    done
    echo "Total: $(totals|grep total|cut -f1)";;
  s)	totals|grep total|cut -f1;;
  ?|*)    totals;;
esac
done

