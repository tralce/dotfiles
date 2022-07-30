#!/bin/bash
# vim:foldmethod=marker
# my personal unison backupper for multiple computers and externals
# Depends: unison nmap

# Variables {{{
version="v2021-05-06"

trap "bye 1" INT

source ~/.bin/src.sh

tout="1000ms"
counter=0
dirNix=
dirWin=
forcedir=""
ip=
oldrdm=0
optExtra=
optFastCheck="-fastcheck true"
optIgnoreArchives=""
optPerms=""
optSyncMode="-auto"
optTerse="-terse"
optTestServer=
ports=
starttime=$(date +%s)
# }}}

# Functions {{{
bye() {
  endtime=$(date +%s)
  echocolor blue "did $counter jobs in $(( (endtime-starttime) / 60 )) minutes, $(( (endtime-starttime) % 60 )) seconds"
  [ -n "$TMUX" ] &&   tmux setw automatic-rename on
  exit "$1"
}

runBackup() {
  if [ -z "$dest" ]
  then
    ipcounter=0
    for ip in "${ips[@]}"
    do
      ((ipcounter=ipcounter+1))
      for port in "${ports[@]}"
      do
        if ncat -z -w $tout "$ip" "$port"
        then
          if [ "$port" -eq 22 ]
          then
            [[ -z "$dirNix" ]] && dest="ssh://$user@$ip//home/$user" || dest="ssh://$user@$ip/$dirNix/$user"
            [[ -z $optPerms ]] && optPerms="-numericids"
          elif [ "$port" -eq 48000 ]
          then
            [[ -z "$dirWin" ]] && dest="socket://$ip:$port/c:/Users/$user" || dest="socket://$ip:$port/$dirWin/$user"
            [[ -z $optPerms ]] && optPerms="-perms 0 -dontchmod"
          fi
          break 2
        fi
      done
      [ "$ipcounter" -eq ${#ips[*]} ] && echocolor red "No responses from ${ips[*]}" && return 1
    done
  fi
  rdmclr=$(( ( RANDOM % 6 ) + 1 ))
  [ $rdmclr -eq $oldrdm ] && rdmclr=7

  if [ -n "$forcedir" ]
  then
    joblist="$forcedir"
  else
    joblist="$*"
  fi

  for job in $joblist
  do
    exitcode=
    echocolor $rdmclr "$dest/$job"
    [ -n "$TMUX" ] && tmux rename-window "backup.sh - $friendlyName/$job"
    if [ "$job" = "MiscBackups" ]
    then
      optFastCheckold=$optFastCheck
      optFastCheck="-fastcheck false"
    fi
    unison $optTerse $optSyncMode $optFastCheck $optIgnoreArchives $optPerms $optTestServer $optExtra ${filebase:-$HOME}/$job $dest/$job
    exitcode=$?
    chmod -R a-xst+X,ug+rw,o-w+r "$HOME"/$job
    if [ "$job" = "MiscBackups" ]
    then
      optFastCheck=$optFastCheckold
    fi
    case $exitcode in
      1)
        echocolor green "Success! Some files were skipped. Exit code 1.";;
      2)
        echocolor red "Something went wrong during the transfer. Exit code 2.";;
      3)
        echocolor red "Failure! Unison seems to have broken somehow. Exit code 3.";;
    esac
    ((counter=counter+1))
  done
  dest=
  optPerms=
  optExtra=
  dirNix=
  dirWin=
  oldrdm=$rdmclr
  filebase=
  friendlyName=
}

usage() {
  echo "backup [-b/-r] [-F] [-h] [-w] [-d dir] operation [operation] ..."
  echo -e "-F\tfastcheck off"
  echo -e "-I\tignore archives"
  echo -e "-b\tbatch mode"
  echo -e "-d\tforce a directory to the loop"
  echo -e "-h\tthis help page"
  echo -e "-r\tresolve mode"
  echo -e "-t\ttestserver mode"
  echo -e "-v\tverbose"
  bye 0
}
# }}}

# Ifs {{{
if [ "$(hostname)" != "nas" ]
then
  echocolor red "This doesn't appear to be nas. This will break everything."
  bye 1
elif [ "$(whoami)" != "tralce" ]
then
  echocolor red "This script has to be run as tralce. This will break everything."
  bye 1
fi

while getopts "mrbd:FhwItv" arg
do
  case $arg in
    d) forcedir="$OPTARG";;
    r) optSyncMode=;;
    v) optTerse="";;
    t) optTestServer="-testserver";;
    b) optSyncMode="-batch";;
    F) optFastCheck="-fastcheck false";;
    h) usage;bye 0;;
    I) optIgnoreArchives="-ignorearchives";;
    *) echocolor red "Invalid option: \"$arg\"";usage;bye 1;;
  esac
done
shift $(( OPTIND - 1 ))

echocolor blue "backup by tralce, $version"

[[ ! "$1" ]] && usage
# }}}

# Core operations {{{
do_eso() {
  for esopc in eli alyx isaac dog odessa dog isaac alyx eli
  do
    echocolor magenta "$esopc..."
    case $esopc in
      eli)    friendlyName="eli";ips=(172.21.2.3);ports=(22 48000);user="tralce";;
      alyx)   friendlyName="alyx";dirWin="y:";ips=(172.21.2.5 172.21.2.15);ports=(22 48000);user="tralce";;
      isaac)  friendlyName="isaac";ips=(172.21.2.4);ports=(22 48000);user="nhadley";;
      dog)    friendlyName="dog";ips=(172.21.2.12);ports=(22 48000);user="tralce";;
      odessa) friendlyName="odessa";ips=(172.21.2.14 172.21.2.13);ports=(22 48000);user="nhadley";;
    esac
  runBackup ESO
  done
}

do_gman() {
  friendlyName="gman"
  ips=(172.21.2.2)
  ports=(22)
  user="tralce"
  runBackup Documents Downloads ISOs Pictures SourceSoftware
}

do_barney() {
  friendlyName="barney"
  ips=(172.21.2.20)
  ports=(22)
  user="tralce"
  runBackup Documents Downloads Pictures/Wallpapers
}

do_judith() {
  friendlyName="judith"
  ips=(172.21.2.16 172.21.2.17)
  ports=(22)
  user="dhadley"
  runBackup Documents Downloads ISOs Pictures/Wallpapers
}

do_alyx() {
  friendlyName="alyx"
  ips=(172.21.2.5 172.21.2.15)
  ports=(22 48000)
  user="tralce"
  dirWin="y:"
  runBackup Documents Downloads ESO ISOs MiscBackups Pictures SourceSoftware
}

do_adrian() {
  friendlyName="adrian"
  ips=(172.21.2.18 172.21.2.19)
  ports=(22)
  dirNix="/Users"
  user=tralce
  optExtra="-servercmd /usr/local/bin/unison"
  optPerms=""
  runBackup Documents Downloads ISOs Music/Music Pictures SourceSoftware
}

do_dog() {
  friendlyName="dog"
  ips=(172.21.2.12)
  ports=(22 48000)
  user="tralce"
  runBackup Documents Downloads ESO Pictures/Wallpapers
}

do_odessa() {
  friendlyName="odessa"
  ips=(172.21.2.14 172.21.2.13)
  ports=(22 48000)
  user="nhadley"
  filebase="$HOME/OtherPeoplesBackups/Nicole"
  runBackup Documents Downloads Music Pictures Videos
  friendlyName="odessa"
  runBackup ESO Pictures/Wallpapers
}

do_arne() {
  friendlyName="arne"
  ips=(172.21.2.31)
  ports=(22)
  user="tralce"
  runBackup Documents Pictures/Wallpapers
}

do_eli() {
  friendlyName="eli"
  ips=(172.21.2.3)
  ports=(22 48000)
  user="tralce"
  runBackup Documents Downloads ESO ISOs Pictures SourceSoftware USB_Toolkits Videos ventoy
}

do_isaac() {
  friendlyName="isaac"
  ips=(172.21.2.4)
  ports=(22 48000)
  user="nhadley"
  filebase="$HOME/OtherPeoplesBackups/Nicole"
  runBackup Documents Downloads Music Pictures Videos
  friendlyName="isaac"
  runBackup ESO Pictures/Wallpapers
}
# }}}

# Main case {{{
while [ "$1" ]
do
  case $1 in
    all)		  do_gman;do_eli;do_alyx;do_eli;do_gman;do_judith;do_barney;do_dog;do_adrian;do_arne;do_isaac;do_odessa;;
    main)     do_gman;do_eli;do_alyx;do_eli;do_gman;;
    adrian)		do_adrian;;
    alyx)		  do_alyx;;
    arne)     do_arne;;
    barney)   do_barney;;
    dog)		  do_dog;;
    eli)		  do_eli;;
    eso)      do_eso;;
    isaac)		do_isaac;;
    judith)		do_judith;;
    gman)     do_gman;;
    odessa)		do_odessa;;
    nicole)   do_isaac;do_odessa;do_isaac;;
    *)		    echocolor red "\"$1\" fail. Try again."
      bye 1;;
  esac
  shift
done
bye 0
# }}}
