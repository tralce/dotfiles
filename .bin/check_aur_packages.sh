#!/bin/bash
command -v pacman &> /dev/null || exit 0
tmp=$(mktemp)
pacman -Qqm >> "$tmp"
tmpsize="$(wc -l "$tmp"|cut -f1 -d ' ')"
if [ "$tmpsize" -gt 0 ]
then
  echo "Found these AUR packages."
  cat "$tmp"
  gum confirm "Remove them?" && sudo pacman -Rsn $(cat "$tmp"|xargs)
fi

