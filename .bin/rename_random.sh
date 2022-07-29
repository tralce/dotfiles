#!/bin/bash
#echo "$*"|while read filename
for filename in "$@"
do
  lc=$(echo "${filename##*.}" | tr '[:upper:]' '[:lower:]'|sed -e "s/jpeg/jpg/g")
  mv -v "$filename" "$(uuidgen).$lc" 2>/dev/null
  #mv -v "$filename" "$RANDOM-$RANDOM-$RANDOM.$lc" 2>/dev/null
done
