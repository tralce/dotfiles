#!/bin/bash

options=

for te in kitty terminator xterm
do
  if which $te &> /dev/null
  then
    $te $options
    break
  fi
done
