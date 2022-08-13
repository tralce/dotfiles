#!/bin/bash

command -v keep-presence &> /dev/null && keep-presence -c &

esodir="$HOME/ESO"
gamedir="$HOME/.games/the-elder-scrolls-online/drive_c/users/$(whoami)/Documents/Elder Scrolls Online/live"

[ -L "$gamedir" ] && unlink "$gamedir"
[ ! -d "$gamedir" ] && mkdir -p "$gamedir"

[ -z "$@" ] && exit 1
[ ! -d "$esodir/$1" ] && exit 1

for oldlink in AddOns Errors Logs SavedVariables Screenshots AddOnSettings.txt UserSettings.txt
do
  [ -L "$gamedir/$oldlink" ] && unlink "$gamedir/$oldlink" || echo "$oldlink is not a symlink!"
done

ln -s "$esodir/tralce/AddOns" "$gamedir/AddOns"
ln -s "$esodir/$1/Errors" "$gamedir/Errors"
ln -s "$esodir/$1/Logs" "$gamedir/Logs"
ln -s "$esodir/$1/SavedVariables" "$gamedir/SavedVariables"
ln -s "$esodir/$1/Screenshots" "$gamedir/Screenshots"
ln -s "$esodir/$1/AddOnSettings.txt" "$gamedir/AddOnSettings.txt"
# ln -s "$esodir/$1/ShaderCache-$(hostname -s).cooked" "$gamedir/ShaderCache.cooked"
ln -s "$esodir/$1/UserSettings-$(hostname -s).txt" "$gamedir/UserSettings.txt"

