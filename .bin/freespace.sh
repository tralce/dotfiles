#!/bin/bash
# Pretty /media fs size for use in Conky

tmp=$(mktemp)
df -hT | grep "/media/" |grep -v "Windows\|nvme0n1p4"| awk 'BEGIN { print "used\tfree\ttotal\t%used" } { printf "%s\t%s\n%s\t%s\t%s\t%s\t%s\n", substr($1, 1, 14), $7, $4, $5, $3, $6, $2 }'|cut -c 1-29 > "$tmp"
if [[ $(wc -l "$tmp"|cut -d ' ' -f1) -gt 1 ]]
then
  cat "$tmp"
fi
rm "$tmp"

