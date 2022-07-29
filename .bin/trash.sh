#!/bin/bash
[ ! -d "${HOME}/.local/share/Trash/files" ] && mkdir -p "${HOME}/.local/share/Trash/files"
ORIGIFS=$IFS
IFS=$(echo -en "\n\b")
if which trash-put &> /dev/null
then
  for filenames in "$@"
  do
    trash-put "$filenames"
  done
else
  echo "trash-cli not installed!"
  for filenames in "$@"
  do
    mv -v -t "${HOME}/.local/share/Trash/files" --backup=numbered "$filenames"
  done
fi
IFS=$ORIGIFS
