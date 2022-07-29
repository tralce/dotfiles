#!/bin/bash
#v2019-12-23
if [ ! "$1" ]
then
  echo "log dir must be specified as the only argument."
  echo "$(basename "$0") /path/to/logs"
  exit 1
else
  pushd "$1" || exit 1
  [ ! -d "./archive/" ] && mkdir ./archive
  for logfile in *.log
  do
    timestamp="$(date +%Y-%m-%d)"
    newlogfile=$logfile.$timestamp
    cp "$logfile" "$newlogfile"
    cat /dev/null > "$logfile"
    gzip -f -9 "$newlogfile"
    mv "$newlogfile".gz archive/
  done
  popd || exit 1
fi
