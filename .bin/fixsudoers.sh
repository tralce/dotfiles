#!/bin/bash

if [ -f $HOME/Scripts/OtherEssentialFiles/global/sudoers ]
then
  if [ $UID = 0 ]
  then
    visudo_binary="$(command -v visudo)"
    cat $HOME/Scripts/OtherEssentialFiles/global/sudoers | EDITOR=tee VISUAL=tee $visudo_binary
  else
    visudo_binary="$(sudo bash -c 'command -v visudo')"
    cat $HOME/Scripts/OtherEssentialFiles/global/sudoers | sudo EDITOR=tee VISUAL=tee $visudo_binary
  fi
fi
