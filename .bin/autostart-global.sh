#!/bin/bash

function run {
  if command -v $1 &> /dev/null
  then
    if ! pgrep -f $1 ;
    then
      $@&
    fi
  fi
}

if test -e ~/.screenlayout/screen.sh
then
  ~/.screenlayout/screen.sh
  sleep 1
fi

xset dpms force on
xset -dpms
xset s noblank
xset s off
xsetroot -cursor_name left_ptr
xmodmap -e 'keycode 135='

(sleep 1 && nitrogen --restore) &
run conky -q

run blueman-applet
run cbatticon
run flameshot
run nm-applet
run numlockx
run pa-applet --disable-notifications
run indicator-sound-switcher

sleep 1

test -e ~/.bin-local/autostart-local.sh && ~/.bin-local/autostart-local.sh
