#!/bin/bash
# depends: inotify-tools transmission-cli trash-cli

if ! command -v inotifywait &> /dev/null
then
  echo "inotify-tools not installed"
  exit 1
fi

while getopts "u:p:h:" arg
do
  case $arg in
    u)  xmuser="$OPTARG";;
    p)  xmpass="$OPTARG";;
    h)  xmhost="$OPTARG";;
  esac
  shift $(( OPTIND - 1 ))
done

while true
do
  trap break INT
  echo "$(date) - starting"
  inotifywait -m $HOME/Downloads $HOME/Pictures/Incoming/Rename -e create -e moved_to | tee | while read dir action filename
  do
    extension=${filename##*.}
    echo "The file '$filename' appeared in directory '$dir' via '$action' - ext $extension"
    sleep 0.1
    case ${extension,,} in
      jpg|jpeg|gif|png|webm|mp4|mov|webp) mv -v --backup=numbered "${dir%/}/$filename" $HOME/Pictures/Incoming/$(uuidgen).${extension,,};;
      aae)                                trash-put "${dir%/}/$filename";;
      torrent)                            transmission-remote "$xmhost" --auth "$xmuser:$xmpass" --trash-torrent --add "${dir%/}/$filename" && trash-put "${dir%/}/$filename";;
    esac
  done
  sleep 1
done
