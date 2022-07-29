#!/bin/bash

workingfile="$(mktemp)"
shuffledfile="$(mktemp)"

while read line
do
  entry=1
  count=$(echo $line|awk '{print $2}')
  ticket="$(echo $line|awk '{print $1}')"

  echo "Entry: $ticket - $count"

  while [[ $entry -le $count ]]
  do
    echo "$ticket - $entry" >> $workingfile
    let ++entry
  done
done

totalentries="$(wc -l $workingfile|awk '{print $1}')"
echo -e "\033[36m$totalentries total entries\n\033[0m"

shuf $workingfile | sed '/^$/d' > $shuffledfile
rm $workingfile

winningticket=$(awk "FNR==$(shuf -i 1-$totalentries -n1) {print \$0}" $shuffledfile)
echo -e "\033[32mWinner is $winningticket\n\033[0m"

rm $shuffledfile
