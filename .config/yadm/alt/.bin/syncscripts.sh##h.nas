#!/bin/bash
# vim: fdm=marker
# v2021-11-02

readarray -t hosts < $HOME/Documents/hostlists/syncscripts

iterations=(1 2)

mode="-auto"
ia=""
perms=

source ~/Scripts/src/src.sh

trap exit 1 INT

usage() {
  echo -e "$(basename $0) [-b] [-h] [-I] [-l] [-r]"
  echo -e "-I\tIgnore archives"
  echo -e "-b\tBatch mode"
  echo -e "-p\tDisable perms"
  echo -e "-o\tOverride hostslist"
  echo -e "-h\tThis help"
}

while getopts "Ibpo:h" arg
do
  case $arg in
    I)	ia="-ignorearchives";;
    b)	mode="-batch";;
    p)	perms="-perms 0 -dontchmod";;
    o)  hosts=($OPTARG);iterations=(1);;
    h)	usage;exit 1;;
    *)	usage;exit 1;;
  esac
done
shift $(( OPTIND - 1 ))

if [ -z "$1" ]
then
  for count in ${iterations[@]}
  do
    echocolor yellow "Iteration $count"
    for remote in ${hosts[@]}
    do
      echocolor green "$remote"
      unison -terse -ui text $mode $ia $perms $HOME/Scripts ssh://$remote/Scripts
      case $? in
        #      0)      echocolor green "Success! Exit code 0.";;
        1)      echocolor green "Success! Some files were skipped. Exit code 1.";;
        2)      echocolor red "Something went wrong during the transfer. Exit code 2.";;
        3)      echocolor red "Failure! Unison seems to have broken somehow. Exit code 3.";;
      esac
    done
  done
else
  unison -terse -ui text $mode $ia $perms $HOME/Scripts ssh://$1/Scripts
fi
