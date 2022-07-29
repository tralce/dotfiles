#!/bin/bash -x
[ -z $1 ] && echo "need a file!" && exit 1
#filename="$1"
#mkdir reenc
for filename in $@
do
  ffmpeg -i ${filename} -crf 22 -map_metadata 0 -preset medium ${filename%.*}-reenc.mp4
done
