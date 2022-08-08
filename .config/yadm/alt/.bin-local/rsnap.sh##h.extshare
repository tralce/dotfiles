#!/bin/bash

fail() {
  echo "FAILURE - rsnap.sh ${1}"
  exit 1
}

hn="$(hostname -s)"
log="/usr/bin/tee -a $HOME/logs/rsnap.sh-${1}.log"

echo "Began $(/usr/bin/date)" | ${log}

echo "Running rsnapshot with ${1}.conf" | ${log}
/usr/bin/rsnapshot -V -c $HOME/${1}.conf ${1} | ${log} || fail

echo "Ended $(/usr/bin/date)" | ${log}
