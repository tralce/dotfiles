#!/bin/bash
# one-off pile-of-jpegs to mp4 converter
fr=10
for i in *.jpg; do
  new=$(printf "%08d.jpg" ${a}) #08 pad to length of 8
  ln ${i} ${new}
  let a=a+1
done
ffmpeg -r $fr -i %08d.jpg -vcodec libx265 -crf 27 $(uuidgen).mp4
rm ????????.jpg
