#!/bin/bash
# vim:foldmethod=marker
# batch package installer for Arch and similar

version="v2021-10-07"

# Variables and starting functions {{{
backtitle="$(basename $0) $version"
tmp=$(mktemp)
tmp2=$(mktemp)
mirtmp=$(mktemp)
conftmp=$(mktemp)
logfile="/tmp/install.arch.sh-$(date +%Y-%m-%d_%H.%M.%S).log"
minimal="on"
typical="off"
desktop="off"
virtual="off"
physical="off"

bye() {
  clear
  [ -f "$tmp" ] && rm -v "$tmp"
  [ -f "$tmp2" ] && rm -v "$tmp2"
  [ -f "$mirtmp" ] && rm -v "$mirtmp"
  [ -f "$conftmp" ] && rm -v "$conftmp"
  exit $1
}

if [ "$UID" -ne "0" ]
then
  echo "This script needs to be run as root."
  exit 1
fi

trap bye 1 INT

while getopts "pvtdMh" arg
do
  case $arg in
    p)  physical="on";;
    v)  virtual="on";;
    t)  typical="on";;
    d)  desktop="on";;
    M)  minimal="off";;
    h)  echo "$(basename $0) [-p] [-v] [-t] [-d] [-M] [-h]"
        echo "-M  disable minimal package selection"
        echo "-d  desktop package selection"
        echo "-h  this help"
        echo "-p  physical package selection"
        echo "-t  typical package selection"
        echo "-v  virtual package selection"
        exit 0;;
  esac
done
shift $(( OPTIND - 1 ))

curl "https://gitea.eclart.xyz/tralce/etc/raw/branch/master/etc/yadm/alt/etc/pacman.d/mirrorlist%23%23d.Arch" > $mirtmp
if ! diff /etc/pacman.d/mirrorlist $mirtmp &>/dev/null
then
  cp $mirtmp /etc/pacman.d/mirrorlist
fi

curl "https://gitea.eclart.xyz/tralce/etc/raw/branch/master/etc/yadm/alt/etc/pacman.conf%23%23d.Arch" > $conftmp
if ! diff /etc/pacman.conf $conftmp &>/dev/null
then
  cp $conftmp /etc/pacman.conf
fi

pacman -Syyuu --noconfirm --needed dialog bc

percent="0.75"
winwidth="$(echo "$percent*$(tput cols)/1"|bc)"
winheight="$(echo "$percent*$(tput lines)/1"|bc)"
winlines="$(echo "($percent*$(tput lines)/1)-5"|bc)"
windowsize1="$winheight $winwidth $winlines"
windowsize2="$winheight $winwidth"
# }}}

# Gigantic dialog {{{
dialog 	--backtitle "$backtitle" \
  --title "Package list" --clear \
  --checklist "" $windowsize1 \
  "base-devel" "Minimal development" $minimal \
  "bash-completion" "bash completions" $minimal \
  "btop" "Awesome system stats" $minimal \
  "colordiff" "Colorized diff wrapper" $minimal \
  "cronie" "Cron daemon" $minimal \
  "dmidecode" "" $physical \
  "fd" "Modern alternative to find" $minimal \
  "fish" "fish shell" $minimal \
  "fping gping" "Some great ping tools" $minimal \
  "fzf" "FuZzy Find" off \
  "gdu" "Best disk usage analyzer" $minimal \
  "gum-bin" "charmbracelet's Gum" $minimal \
  "gum-bin" "gum for shell scripts" $minimal \
  "htop" "Better than top" $minimal \
  "inotify-tools transmission-cli" "" $minimal \
  "libqalculate" "Command line calculator" $minimal \
  "lsb-release" "what os am I" $minimal \
  "lsd" "better than ls" $minimal \
  "lshw" "" $physical \
  "man-db" "What were they thinking, not including this?" $minimal \
  "mlocate" "find / -name is for suckers" $minimal \
  "moreutils" "Little command line utils" $minimal \
  "ncdu" "Best disk usage analyzer" $minimal \
  "neovim" "Greatly improved vim" $minimal \
  "oath-toolkit" "OTP tools" $minimal \
  "openssh" "Secure shell daemon" $minimal \
  "pacman-contrib reflector pacgraph pkgfile pacutils" "Extra tools for pacman" $minimal \
  "perl-rename" "The rename we know and love" $minimal \
  "postfix s-nail" "emailed notifications" off \
  "progress" "Show progress of running coreutils" $minimal \
  "pv" "Pipe viewer" $minimal \
  "pwgen" "Great password generator" $minimal \
  "pydf" "Better than df -h" $minimal \
  "ranger highlight libcaca perl-image-exiftool mediainfo odt2txt screen" "Console file manager" $minimal \
  "rmlint" "File deduplicator script" $minimal \
  "rsync" "Maximum file copying" $minimal \
  "sc-im-git" "Command line spreadsheet" $minimal \
  "sudo" "Better than logging in as root" $minimal \
  "tldr" "man pages for the busy" $minimal \
  "tmux" "Better than screen" $minimal \
  "topgrade-git" "Batch updates" $minimal \
  "trash-cli" "CLI trash manager" $minimal \
  "udisks2" "Auto mounting" $physical \
  "usbutils" "Why isn't lsusb included?" $physical \
  "wget" "A pretty good downloader" $minimal \
  "yadm" "yet another dotfile manager" $minimal \
  "zsh zsh-doc zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search" "ZShell - better than bash" $minimal \
  "" "" off \
  "axel" "Multi threaded wget" $minimal \
  "dnsutils" "DNS utilities" $minimal \
  "elinks" "CLI web browser" off \
  "gnu-netcat" "nc is important" $minimal \
  "inetutils" "hostname etc" $minimal \
  "iperf" "Network performance" $minimal \
  "lynx" "CLI web browser" off \
  "net-tools" "ifconfig etc" $minimal \
  "w3m" "CLI web browser" $typical \
  "whois" "DNS lookup" $minimal \
  "" "" off \
  "ddrescue" "Error tolerant dd" $physical \
  "foremost" "Data recovery from headers" $physical \
  "gptfdisk" "Fdisk suite for GPT disks" $physical \
  "hdparm" "View and set disk paramaters" $physical \
  "parted" "" $physical \
  "parted cloud-guest-utils" "" $virtual \
  "testdisk" "Partition table recovery, includes photorec" $physical \
  "" "" off \
  "snapper" "btrfs snapshot manager" off \
  "btrfs-progs" "Btrfs" $typical \
  "dosfstools mtools" "VFAT" $typical \
  "f2fs-tools" "F2FS" $typical \
  "jfsutils" "JFS" $typical \
  "nfs-utils" "Network file system" $typical \
  "nilfs-utils" "NILFS" $typical \
  "ntfs-3g" "NTFS" $typical \
  "reiserfsprogs" "ReiserFS" $typical \
  "squashfs-tools squashfuse" "SquashFS" $minimal \
  "sshfs" "Mount sftp share" $minimal \
  "udftools" "UDF" $typical \
  "xfsprogs" "XFS" $typical \
  "" "" off \
  "cabextract" ".cab" $typical \
  "cpio" ".cpio" $typical \
  "lha" ".lzh" $minimal \
  "p7zip" ".7z" $minimal \
  "rpmextract" ".rpm" $typical \
  "unace" ".ace" $typical \
  "unrar" ".rar" $minimal \
  "unshield" "installSHIELD" $typical \
  "unzip zip" ".zip" $minimal \
  "" "" off \
  "bmon" "Lots of realtime stats" off \
  "mtr" "Better than traceroute" $typical \
  "nethogs" "Net usage by IP/program" off \
  "nmap" "The best port scanner" $minimal \
  "wavemon" "Wireless stats for days" off \
  "" "" off \
  "acpi" "ACPI" $physical \
  "alsa-utils" "Volume mixer and some other stuff" off \
  "arch-wiki-lite" "The ArchWiki, in console" $typical \
  "bchunk ccd2iso mdf2iso nrg2iso" "Disk image converters" off \
  "dos2unix" "Convert DOS formats to UNIX" off \
  "ffmpeg" "Video converter" off \
  "imagemagick" "Image converter" off \
  "jq yq" "json and yaml text processors" $typical \
  "lm_sensors" "Temps, speeds, voltages" $physical \
  "lsof" "list open files" $typical \
  "most" "even better pager" off \
  "nnn bat mediainfo" "nnn file manager" off \
  "nodejs" "node.js" off \
  "pulseaudio pulsemixer" "pulseaudio" $physical \
  "rsnapshot" "rsync based backupper" off \
  "smartmontools" "SMART monitoring" $physical \
  "vim vimpager" "Vim is the best" off \
  "" "" off \
  "nvidia nvidia-utils nvidia-libgl" "NVidia (proprietary)" off \
  "nvidia-dkms nvidia-utils nvidia-libgl" "NVidia (proprietary)" off \
  "xf86-video-amdgpu mesa " "Newer AMD" off \
  "xf86-video-ati" "ATI/AMD" off \
  "xf86-video-intel" "Intel" off \
  "xf86-video-nouveau" "NVidia (open)" off \
  "xf86-video-vesa" "Last resort" off \
  "" "" off \
  "arandr" "A great RandR wrapper" $desktop \
  "arc-gtk-theme arc-solid-gtk-theme" "Arc theme" $desktop \
  "gdm" "" off \
  "gdm-prime" "" off \
  "gnome-themes-standard" "Ok themes" $desktop \
  "lxdm" "A great display manager" $desktop \
  "lxrandr" "An ok RandR wrapper" $desktop \
  "libertinus-font noto-fonts ttf-bitstream-vera ttf-dejavu ttf-droid ttf-liberation ttf-ubuntu-font-family noto-fonts-emoji ttf-twemoji ttf-twemoji-color" "More fonts than you can stand" $desktop \
  "papirus-icon-theme" "Papirus Icon Theme" $desktop \
  "xorg-server xclip xorg-apps xorg-xev xorg-xmodmap xorg-xinit xorg-xkill xterm xpra" "Essential X" $desktop \
  "" "" off \
  "awesome lxappearance nitrogen rofi" "awesome" $desktop \
  "cinnamon" "Cinnamon DE" off \
  "i3-gaps i3lock i3blocks i3status obconf dmenu nitrogen lxappearance" "i3 WM" off \
  "mate" "MATE DE" off \
  "mate-extra" "MATE DE" off \
  "xmonad xmonad-contrib haskell-dbus xmonad-log hlint rofi nitrogen lxappearance" "" off \
  "" "" off \
  "blueberry" "Blueberry (from Mint) bluetooth" off \
  "blueman" "Blueman bluetooth" off \
  "bluez bluez-utils" "bluez" off \
  "network-manager-applet" "" $desktop \
  "" "" off \
  "gnome-keyring libsecret seahorse" "GNOME Keyring for saving passwords" $desktop \
  "" "" off \
  "gvfs-afc gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb" "Extra support for file managers" $desktop \
  "nemo nemo-fileroller nemo-preview nemo-terminal" "Cinnamon Nemo file manager" $desktop \
  "pcmanfm" "Absurdly lightweight file manager" off \
  "thunar tumbler thunar-archive-plugin thunar-media-tags-plugin libgsf ffmpegthumbnailer" "Light file manager from XFCE" off \
  "" "" off \
  "discord" "Text and voice chat" off \
  "eog" "Eye of GNOME Image Viewer" $desktop \
  "firefox" "Web" $desktop \
  "flameshot-git kguiaddons qt5-wayland" "Decent screenshots" $desktop \
  "qalculate-gtk" "calculator" $desktop \
  "gparted" "The very best partition editor" $desktop \
  "kitty" "Best terminal evah!" $desktop \
  "numlockx" "NumLock ON" off \
  "synergy-git" "Cross platform keyboard and mouse sharing" off \
  "" "" off \
  "gimp" "GNU Image Manipulation Program" off \
  "howl" "Howl text editor" off \
  "libreoffice-fresh" "Full office suite" off \
  "libreoffice-still" "Full office suite" off \
  "pinta" "Like Paint.NET" off \
  "abiword gnumeric" "Lightweight office" off \
  "" "" off \
  "asciinema" "" $desktop \
  "baobab" "Disk usage analyzer" off \
  "bleachbit" "If CCleaner was open source" off \
  "conky" "Desktop system stats" $desktop \
  "file-roller" "Archive tool" off \
  "firefox" "Firefox" $desktop \
  "gnome-calculator" "A calculator" $desktop \
  "gnome-disk-utility" "GNOME disk utility" $desktop \
  "gsmartcontrol" "GUI SMART tool" $desktop \
  "linssid" "Wifi scanner" off \
  "pa-applet-git pavucontrol" "Pulseaudio GUI" $desktop \
  "picom" "Composite manager" $desktop \
  "poppler" "PDF support for ranger" $desktop \
  "remmina freerdp" "Good remote admin" off \
  "ueberzug" "image support for ranger" $desktop \
  "veracrypt" "Veracrypt" off \
  "virtualbox" "VirtualBox hypervisor" off \
  "vlc" "VLC Media Player" $desktop \
  "xcompmgr" "A different compositor" off \
  "" "" off \
  "steam" "Steam" off \
  "lib32-mesa" "NVIDIA/AMD open source" off \
  "lib32-nvidia-utils" "nvidia proprietary" off \
  "" "" off \
  "openvpn" "" $typical \
  "" "" off \
  "flatpak" "" off \
  "docker docker-compose" "docker" off \
  "" "" off \
  "wine wine-gecko wine-mono" "wine" off \
  "lutris wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader" "lutris wine manager" off \
  "playonlinux" "PlayOnLinux" off \
  "" "tralce repo" off \
  "adduser" "" $typical \
  "apg" "" off \
  "clipit" "" off \
  "fclones" "" $typical \
  "google-chrome" "" off \
  "j4-dmenu-desktop" "" off \
  "nerd-fonts-ubuntu-mono" "" $desktop \
  "ookla-speedtest-bin" "" $typical \
  "pkgtools" "" $typical \
  "polybar" "" off \
  "termius-app" "" off \
  "tomb tomb-kdf" "" $typical \
  "unison-tralce" "" $minimal \
  "webmin" "" off \
  "yay-bin" "" $minimal \
  2>> $tmp
  # }}}

# Rest of the script {{{
[ "$?" -ne 0 ] && bye 1

numpackages="$(cat $tmp|sed -e "s/\"//g"|xargs -n 1|sort -u|wc -l)"
cat $tmp|sed -e "s/\"//g"|xargs -n 1|sort -u >> $tmp2
dialog	--backtitle "$backtitle" \
  --title "$numpackages packages chosen to install" \
  --clear \
  --exit-label " PROCEED " \
  --textbox "$tmp2" $windowsize2

[ $? -ne 0 ] && bye 1

echo "Packages chosen:" >> $logfile
cat $tmp2 >> $logfile
echo "Starting pacman..." >> $logfile

packages="$(cat $tmp|uniq|xargs)"

clear

pacman -Syyu --needed --color=always $packages

enableunit() {
  enabchoice=
  startchoice=
  if pacman -Qi $1 &> /dev/null
  then
    if ! systemctl is-enabled $2 &>/dev/null
    then
      read -p "$1 is installed, do you want to enable $2? " -n 1 enabchoice
      echo
      if [ ${enabchoice,,} = "y" ]
      then
        systemctl enable $2
        [ "$2" != "lxdm" ] && read -p "Do you want to start $2 now? " -n 1 startchoice
        echo
        if [ ${startchoice,,} = "y" ]
        then
          systemctl start $2
        fi
      fi
    fi
  fi
}
enableunit bluez bluetooth
enableunit connman connman
enableunit cronie cronie
enableunit networkmanager NetworkManager
enableunit openssh sshd
enableunit postfix postfix
enableunit lxdm lxdm
enableunit qemu-guest-agent qemu-guest-agent

bye 0
# }}}
