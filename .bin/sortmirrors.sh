# vim:syn=bash
#!/bin/bash
#v2016.02.08.0
# Get a new Arch mirrorlist then sort it by speed

trap exit 1 INT

tmp="$(mktemp)"
# inputfile="/etc/pacman.d/mirrorlist.pacnew"
inputfile="$tmp"
outputfile="/etc/pacman.d/mirrorlist"

source ~/Scripts/src/src.sh

usage() {
  echo "sortmirrors.sh [-i inputfile] [-o outputfile]"
  echo "inputfile default: $inputfile"
  echo "outputfile default: $outputfile"
  exit "$1"
}

while getopts "i:o:h" arg
do
  case $arg in
    i)	inputfile="$OPTARG";;
    o)	outputfile="$OPTARG";;
    h)	usage 0;;
    ?|*)	usage 1;;
  esac
done

shift $(( OPTIND - 1 ))

echo -e "Input file:\t$inputfile"
echo -e "Output file\t$outputfile"
echo -e "If input file isn't specified, reflector\nwill download a fresh one from MirrorStatus"
echo -e "Enter to continue... \n"
read enterKey

if [ -f "$outputfile" ]
then
  if [ "$inputfile" == "$tmp" ]
  then
    #reflector --country 'United States' -l 200 --sort rate --verbose --save /etc/pacman.d/mirrorlist
    reflector --country "United States" --age 3 --fastest 7 --sort rate --verbose --save "$tmp"
    #curl "https://www.archlinux.org/mirrorlist/?country=US&protocol=http&ip_version=4" >> $tmp
  else
    cp "$inputfile" "$tmp"
  fi
  sed -i -e 's/^#Server/Server/' -e '/^##/d' -e '/^$/d' "$tmp"
  rankmirrors -v -n 10 "$tmp" | checkroot tee "$outputfile"
  rm "$tmp"
else
  echo "$outputfile doesn't seem to exist."
  exit 1
fi
