#!/bin/bash

source ~/Scripts/src/src.sh

dirs=(
  Archive
  Desktop
  Documents
  Downloads
  ESO
  Incoming
  ISOs
  Media
  MiscBackups
  Music
  OtherPeoplesBackups
  Pictures
  Proxmox
  SourceSoftware
  tmp
  USB_Toolkits
  Videos
)

echocolor green "$HOME/Scripts..."
chmod -R a-st,u+rwx,go-w+rx "$HOME"/Scripts
for dir in ${dirs[@]}
do
  if [ -d "$HOME/$dir" ]
  then
    echocolor green "$HOME/$dir..."
    chown -R "$(id -un)":"$(id -gn)" "$HOME"/$dir
    chmod -R a-xst+X,ug+rw,o-w+r "$HOME"/$dir
  else
    echocolor red "$HOME/$dir does not exist. Skipping."
  fi
done

