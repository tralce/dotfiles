#!/bin/bash
# vim: fdm=marker
# otg.sh v2022-06-02: on-the-go backupper so I don't have to rewrite backup.sh
# to support being run on other computers.

trap "bye 1" INT # {{{
source ~/Scripts/src/src.sh
dest="$HOME"
dirlist=
fast="-fastcheck true"
flip=0
hn="$(hostname -s)"
ia=
perms=
srclist=(ssh://nas.eclart.xyz//home/tralce)
# }}}

bye() { # {{{
  [ -n "$TMUX" ] && tmux setw automatic-rename on
  exit "$1"
} # }}}

doSync() { # {{{
  for src in ${srclist[@]}
  do
    for dir in ${dirlist[@]}
    do
      if test -d ${dest}/${dir}
      then
        [ -n "$TMUX" ] && tmux rename-window "otg.sh - ${src}/${dir}"
        echocolor green ${dest}/${dir}
        if [ $flip -eq 1 ]
        then
          unison -auto $perms $ia $fast ${dest}/${dir} ${src}/${dir}
        else
          unison -auto $perms $ia $fast ${src}/${dir} ${dest}/${dir}
        fi
      else
        echocolor red ${dest}/${dir} does not exist on this system.
      fi
    done
  done
  bye 0
} # }}}

while getopts "FIo:" arg # {{{
do
  case $arg in
    I) ia="-ignorearchives";;
    F) fast="-fastcheck false";;
    o) src="$OPTARG";flip=1;;
    *) bye 1;;
  esac
done
shift $(( OPTIND - 1 )) # }}}

case "$1" in # {{{
  camp)       [ -z $2 ] && bye 1 || dirlist=(Documents Downloads Scripts);src="ssh://${2}//home/tralce";;
  backup)     dirlist=(.aws .gnupg Desktop Documents Downloads ESO ISOs Pictures/Wallpapers Scripts SourceSoftware);;
  crypt)      dirlist=(crypt);src="ssh://nas.eclart.xyz//media";dest="/media";;
  downloads)  dirlist=(Downloads);;
  documents)  dirlist=(Documents);;
  eso)        dirlist=(ESO);;
  mb)         dirlist=(MiscBackups);;
  pictures)   dirlist=(Pictures);;
  quick)      dirlist=(Documents Downloads Scripts);;
  scripts)    dirlist=(Scripts);;
  usb)        unset srclist;for drive in /media/USB128GB-0 /media/USB128GB-1;do [ -d $drive ] && srclist+=($drive);done;dirlist=(Documents ISOs Scripts SourceSoftware USB_Toolkits ventoy);perms="-fat";flip=1;;
  *)          echo 'Valid options: [-I] [-F] '
    echo 'backup   | downloads | eso     | mb'
    echo 'pictures | quick     | scripts | usb'
    bye 1;;
esac

[ -n ${dirlist} ] && doSync # }}}
