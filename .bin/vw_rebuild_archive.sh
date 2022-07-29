#!/bin/bash

cd "$HOME/Documents/vw/tech/archived_scripts/" || exit 1

[ ! -f " index/wiki" ] && touch index.wiki

find . -type f -not -name "*.wiki" -exec mv -v '{}' '{}.wiki' \;

for script in $(find . -name "*.wiki"|grep -v index.wiki|sed -e "s/\.\///g")
do
  if ! grep -q "${script}" index.wiki
  then
    echo "[[${script}]]"|tee -a index.wiki
  fi
done


cd "$HOME/Documents/vw/tech/archived_configs/" || exit 1

[ ! -f " index/wiki" ] && touch index.wiki

find . -type f -not -name "*.wiki" -exec mv -v '{}' '{}.wiki' \;

for config in $(find . -name "*.wiki"|grep -v index.wiki|sed -e "s/\.\///g")
do
  if ! grep -q "${config}" index.wiki
  then
    echo "[[${config}]]"|tee -a index.wiki
  fi
done
