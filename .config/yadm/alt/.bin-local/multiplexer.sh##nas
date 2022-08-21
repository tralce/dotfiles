#!/bin/bash

# if which zellij &> /dev/null
# then
#   if [ -z "$ZELLIJ" -a -z "$SUDO_UID" ]
#   then
#     zellij --layout compact attach --create "$(hostname -s)"
#   fi
if which tmux &> /dev/null
then
  if [ -z "$TMUX" -a -z "$SUDO_UID" ]
  then
    tmux has-session -t $(hostname -s) &> /dev/null && tmux attach-session -t $(hostname -s) -d || (tmux attach-session -d &> /dev/null || tmux -2 -u new-session -s $(hostname -s))
  fi
elif which screen &> /dev/null
then
  [ -z "$STY" ] && TERM=xterm screen -q -D -R
fi
