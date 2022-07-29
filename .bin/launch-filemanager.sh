#!/bin/bash

options=

for fm in nemo thunar pcmanfm nautilus caja
do
  if which $fm &> /dev/null
  then
    $fm $options
    break
  fi
done
