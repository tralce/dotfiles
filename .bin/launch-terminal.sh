#!/bin/bash

options=

for te in alacritty kitty terminator gnome-terminal urxvt xterm
do
  if which $te &> /dev/null
  then
    $te $options
    break
  fi
done
