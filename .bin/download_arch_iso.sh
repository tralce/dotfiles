#!/bin/bash
# v2016.03.01.0
# quick one-off or cron-run Arch ISO downloader

releasename="$(curl -s https://archlinux.org/download/|grep -o '[0-9]\{4\}\.[0-9]\{2\}\.[0-9]\{2\}'|head -n 1)"
echo -e "\n\n Latest release: $releasename \n\n"
pushd $HOME/ISOs/OSes/
if wget -nv "http://mirrors.kernel.org/archlinux/iso/$releasename/archlinux-$releasename-x86_64.iso" -O archlinux-current-x86_64.iso
then
  $HOME/Scripts/trash.sh archlinux-????.??.??-x86_64.iso
  mv -v archlinux-current-x86_64.iso archlinux-$releasename-x86_64.iso
else
  echo "wget seems to have failed. stopping."
fi
popd
