#!/bin/bash

curterm="$(ps -o comm= -p "$(($(ps -o ppid= -p "$(($(ps -o sid= -p "$$")))")))")"

att() {
  if which zellij &> /dev/null
  then
    if [ -z "$ZELLIJ" -a -z "$SUDO_UID" ]
    then
      # zellij attach $(hostname -s) &> /dev/null || zellij -s $(hostname -s)
      # zellij
      zellij attach --create "$(hostname -s)"
    fi
  elif which tmux &> /dev/null
  #if which tmux &> /dev/null
  then
    if [ -z "$TMUX" -a -z "$SUDO_UID" ]
    then
      tmux has-session -t $(hostname -s) &> /dev/null && tmux attach-session -t $(hostname -s) -d || (tmux attach-session -d &> /dev/null || tmux -2 -u new-session -s $(hostname -s))
    fi
  elif which screen &> /dev/null
  then
    [ -z "$STY" ] && TERM=xterm screen -q -D -R
  fi
}

case $curterm in
  nemo) exit 0;;
  *)    att;;
esac
