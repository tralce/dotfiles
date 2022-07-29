#!/bin/bash

browserlist=(
  firefox
  google-chrome-stable
  chromium
  epiphany
  midori
  )

options=

for browser in ${browserlist[@]}
do
  if which $browser &> /dev/null
  then
    case $browser in
      chromium)		options="--disable-session-restore-bubble --disable-restore-session-state";;
      google-chrome-stable)	options="--disable-session-restore-bubble --profile-directory=Default --disable-gpu";;
    esac
    $browser $options
    break
  fi
done
