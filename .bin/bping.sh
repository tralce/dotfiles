#!/bin/bash
# bping.sh by tralce v2022-06-03
# visual and beepy wrapper for nc and ping

usage="usage: bping.sh [-d n] [-f] [-p n] [-t n] [ip/host] [ip/host...]

|------------+---------------------------------------|
| argument   | purpose                               |
|------------+---------------------------------------|
| -d delay   | set delay in seconds                  |
| -f         | beep on failures instead of successes |
| -p port    | check a port instead of pinging       |
| -t timeout | set timeout in seconds                |
|------------+---------------------------------------|

If multiple hosts or IPs are specified, they will be pinged in
order.
"

source ~/.bin/src.sh

cnt=1
delay="1"
timeout="1"
port=
alarm_g="\a"
alarm_r=""

while getopts "hd:t:p:f" arg
do
  case $arg in
    d)	delay="$OPTARG";;
    t)	timeout="$OPTARG";;
    p)  port="$OPTARG";;
    f)  alarm_g="";alarm_r="\a";;
    h)	echo "$usage"; exit 1
  esac
done
shift $(( OPTIND - 1 ))

if [ -z "$1" ]
then
  echo "$usage"
  exit 1
fi

hostlist=($@)

bping() {
  while true
  do
    for host in ${hostlist[@]}
    do
      if ping -W "$timeout" -c 1 "$host" &> /dev/null;then
        echocolor green "$host - Success - Attempt #${cnt}${alarm_g}";
      else
        echocolor red "$host - Failure - Attempt #${cnt}${alarm_r}"
      fi
      sleep "$delay"
    done
    ((cnt++))
  done
}

bpc() {
  while true
  do
    for host in ${hostlist[@]}
    do
      if nc -z -w"$timeout" "$host" "$port" &> /dev/null
      then
        echocolor green "$host:$port - Success - Attempt #${cnt}${alarm_g}";
        sleep "$delay"
      else
        echocolor red "$host:$port - Failure - Attempt #${cnt}${alarm_r}"
        sleep "$delay"
      fi
    done
    ((cnt++))
  done
}

if [ -z $port ]
then
  bping
else
  bpc
fi
