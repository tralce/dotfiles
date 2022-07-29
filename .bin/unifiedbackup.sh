#!/bin/bash
# 2020-01-27
# unison backupper script that automatically chooses between
# Windows, macOS, and Linux, and runs Unison accordingly.

altip=
mainip=
debug=
dirlist="Desktop Documents Downloads Music Pictures"
ia=
logdir="$HOME/logs"
mode="-auto"
noout=
prefix=
scriptname="$(basename $0)"
unisonpath=

trap exit 1 INT

helptext() {
  echo "$scriptname [-b/-r] [-I] [-h] [-d] [-P] [-s path] [-p path] [-U path] [-i ip] [-n hostname] [-u username] [-a ip]"
  echo -e "-a\tSpecify alternate IP. Good for computers with wireless and ethernet."
  echo -e "-b\tBatch mode. Output to ~/logs/computer.log. Don't ask about any conflicts. Good for cron."
  echo -e "-d\tDebug mode."
  echo -e "-h\tThis help."
  echo -e "-I\tIgnore archives. Start the scans from scratch."
  echo -e "-i\tRequired. Specify remote IP."
  echo -e "-n\tRequired. Specify computer name."
  echo -e "-P\tPrefer remote. Good for cron."
  echo -e "-p\tSet prefix for Windows replicas."
  echo -e "-r\tResolve mode. Ask about every conflict."
  echo -e "-s\tSpecify path to the directory where the backups are stored."
  echo -e "-U\tSpecift path to unison on remote."
  echo -e "-u\tRequired. Specify remote username."
}

date

while getopts "a:bdhIi:n:Pp:rs:U:u:" arg
do
  case $arg in
    a)	altip="$OPTARG";;
    b)	mode="-batch -silent";;
    d)	debug="yes";;
    h)	helptext && exit 0;;
    I)	ia="-ignorearchives";;
    i)	mainip="$OPTARG";;
    n)	remname="$OPTARG";;
    P)	preferremote=1;;
    p)	prefix="$OPTARG";;
    r)	mode="";;
    s)	storagedir="$OPTARG";;
    U)	unisonpath="-servercmd $OPTARG";;
    u)	remuser="$OPTARG";;
  esac
done
shift $(( OPTIND - 1 ))

[ -z "$mainip" ] && helptext && exit 1
[ -z "$remname" ] && helptext && exit 1
[ -z "$remuser" ] && helptext && exit 1

if nc -w 5 -z $mainip 48000
then
  echo "Port 48000 open. Windows assumed."
  [ -z "$prefix" ] && prefix="c:/Users/$remuser"
  unisonparttwo="socket://$mainip:48000/$prefix"
  dirlist="$dirlist Videos"
elif nc -w 5 -z $mainip 22
then
  echo "Port 22 open. *nix assumed."
  if [ -z "$prefix" ]
  then
    if ssh $remuser@$mainip "[ -d /home/$remuser ]"
    then
      echo "/home/$remuser exists."
      prefix="/home/$remuser"
      dirlist="$dirlist Videos"
    elif ssh $remuser@$mainip "[ -d /Users/$remuser ]"
    then
      echo "/Users/$remuser exists."
      prefix="/Users/$remuser"
      dirlist="$dirlist Movies"
    fi
  fi
  unisonparttwo="ssh://$remuser@$mainip/$prefix"
else
  echo "Neither port 22 or 48000 on $mainip were open."
  if [ -n $altip ]
  then
    echo "Trying alternate IP $altip."
    if nc -w 5 -z $altip 48000
    then
      echo "Port 48000 open. Windows assumed."
      [ -z "$prefix" ] && prefix="c:/Users/$remuser"
      unisonparttwo="socket://$altip:48000/$prefix"
      dirlist="$dirlist Videos"
    elif nc -w 5 -z $altip 22
    then
      echo "Port 22 open. *nix assumed."
      if [ -z "$prefix" ]
      then
        if ssh $remuser@$altip "[ -d /home/$remuser ]"
        then
          echo "/home/$remuser exists."
          prefix="/home/$remuser"
          dirlist="$dirlist Videos"
        elif ssh $remuser@$altip "[ -d /Users/$remuser ]"
        then
          echo "/Users/$remuser exists."
          prefix="/Users/$remuser"
          dirlist="$dirlist Movies"
        fi
      fi
      unisonparttwo="ssh://$remuser@$altip/$prefix"
    else
      echo "Neither port 22 or 48000 on $altip were open. Exiting."
      exit 1
    fi
  fi
fi

if [ ! -z $debug ]
then
  echo "remuser:       $remuser"
  echo "mainip:        $mainip"
  echo "altip:         $altip"
  echo "prefix:        $prefix"
  echo "unisonparttwo: $unisonparttwo"
fi

START=$(date +%s)

for dir in $dirlist
do
  [ ! -z $preferremote ] && prefer="-prefer $unisonparttwo/$dir"
  unisoncmd="unison -terse $mode $ia -perms 0 -dontchmod $unisonpath $prefer -logfile $logdir/unifiedbackup.sh-$remname.log $storagedir/$remname/$remuser/$dir $unisonparttwo/$dir"
  echo "$unisoncmd"
  [ ! -d "$storagedir/$remname/$remuser/$dir" ] && mkdir -p "$storagedir/$remname/$remuser/$dir"
  $unisoncmd
done
FINISH=$(date +%s)
echo -e "\ntotal time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds\n"
