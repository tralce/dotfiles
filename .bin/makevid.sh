#!/bin/bash
# one-off video maker

trap exit INT
a=0
delay=10
workingdir="$(pwd)"
format="mp4"

while getopts "gd:" arg
do
  case $arg in
    g)	format="gif";;
    d)	delay="$OPTARG";;
  esac
done
shift $(( OPTIND - 1 ))

if ! ls *.jpg 1> /dev/null 2>&1
then
  echo "No jpgs here!"
  exit 1
fi

do_the_thing() {
  for i in *.jpg
  do
    new=$(printf "%08d.jpg" ${a}) #08 pad to length of 8
    ln ${i} ${new}
    let a=a+1
  done
  ffmpeg -r $delay -i %08d.jpg  $(uuidgen).$format
  rm ????????.jpg
}

echo "This will operate on all .jpg files in the current working directory:"
echo "$workingdir"
read -p "Are you absolutely sure? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  do_the_thing
fi

