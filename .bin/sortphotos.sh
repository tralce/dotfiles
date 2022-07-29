#!/bin/bash
inputdir="$(pwd)"
outputdir="$(pwd)"
recurse=

while getopts "i:o:d:r" arg
do
  case $arg in
    i)	inputdir="$OPTARG";;
    o)	outputdir="$OPTARG";;
    d)	inputdir="$OPTARG"
      outputdir="$OPTARG";;
    r)  recurse="-r";;
    *)      exit 1;;
  esac
done
shift $(( OPTIND - 1 ))

echo "Input dir:"
echo "$inputdir"
echo "Output dir:"
echo "$outputdir"
read -p "Proceed? (y/n)" -r -n 1 proceed
case $proceed in
  y|Y)	exiftool '-Directory<CreateDate' -d "$outputdir"/%Y/%m $recurse "$inputdir";;
  *)	echo "Not proceeding."
    exit 1;;
esac
