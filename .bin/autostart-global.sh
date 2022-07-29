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

setxkbmap -option compose:menu
setxkbmap -option compose:ralt
xset dpms force on
xset -dpms
xset s noblank
xset s off
xsetroot -cursor_name left_ptr
(sleep 1 && nitrogen --restore) &
run conky -q
