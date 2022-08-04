#!/bin/bash
# checks for orphaned pacman packages and offers to remove them

if command -v apt &> /dev/null
then
  sudo apt autoremove
elif command -v pacman &> /dev/null
then
  tmp=$(mktemp)
  pacman -Qqdt >> "$tmp"
  tmpsize="$(wc -l "$tmp"|cut -f1 -d ' ')"
  if [ "$tmpsize" -gt 0 ]
  then
    echo "Found these orphans."
    cat "$tmp"
    read -p "Remove them? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
      sudo pacman -Rsn $(cat "$tmp"|xargs)
    fi
  elif [ "$tmpsize" -eq 0 ]
  then
    echo "No orphans found."
  fi
  rm "$tmp"
fi
