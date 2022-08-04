#!/bin/bash

while getopts "e:" arg
do
  case $arg in
    e) newext="$OPTARG";;
    *) exit 1;;
  esac
done
shift $(( OPTIND - 1 ))

[ -z $newext ] && exit 1
[ -z $1 ] && exit 1

for fn in $@
do
  case $newext in
    png) convert $fn ${fn%.*}.png;;
    jpg) convert $fn ${fn%.*}.jpg;;
    gif) convert $fn ${fn%.*}.gif;;
    mp4) ffmpeg -i $fn ${fn%.*}.mp4;;
    *)   exit 1;;
  esac
  [ $? -eq 0 ] && trash-put $fn
done
