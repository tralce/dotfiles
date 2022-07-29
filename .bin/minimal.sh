#!/bin/bash

echo "minimal.sh v2022-07-13.0"

filelist=
installlist=

if [ -z "${SILENT+x}" ]
then
  :
else
  authkeys=y
  trust=n
  fixsym=y
  fixsudo=y
  newauth=y
  newssh=n
fi

if [ -z "${TRUST+x}" ]
then
  :
else
  authkeys=y
  trust=y
  fixsym=y
  fixsudo=y
  newauth=y
  newssh=y
fi

checkroot() {
  if [ "$UID" -eq "0" ]
  then
    $*
  else
    sudo $*
  fi
}

if [ -e "$HOME/Scripts/index.html" ]
then
  echo "Looks like you don't need to run this."
  exit 1
fi

# command -v  &> /dev/null || installlist+=()
command -v colordiff &> /dev/null || installlist+=(colordiff)
command -v curl &> /dev/null || installlist+=(curl)
command -v diff &> /dev/null || installlist+=(diffutils)
command -v git &> /dev/null || installlist+=(git)
command -v nc &> /dev/null || installlist+=(netcat)
command -v screen &> /dev/null || installlist+=(screen)
command -v wget &> /dev/null || installlist+=(wget)

if [[ -n ${installlist[@]} ]]
then
  if command -v apt &> /dev/null
  then
    checkroot apt update
    checkroot apt install -y ${installlist[@]}
  elif command -v pacman &> /dev/null
  then
    checkroot pacman -Sy ${installlist[@]}
  fi
fi

filelist=(
  OtherEssentialFiles/global/aliases.sh
  OtherEssentialFiles/global/home/.bashrc
  OtherEssentialFiles/global/home/.vim/autoload/plug.vim
  OtherEssentialFiles/global/home/.vimrc
  OtherEssentialFiles/global/sudoers
  OtherEssentialFiles/path.sh
  backupall.sh
  badsect.sh
  bping.sh
  fixsshperms.sh
  fixsudoers.sh
  fixsymlinks.sh
  freemem.sh
  iso2usb.sh
  prepare_disk.sh
  regenerate_host_keys.sh
  rmkey.sh
  src/src.sh
)

command -v fish &> /dev/null && filelist+=(OtherEssentialFiles/global/home/.config/fish/config.fish)
command -v ranger &> /dev/null && filelist+=(OtherEssentialFiles/global/home/.config/ranger/commands.py OtherEssentialFiles/global/home/.config/ranger/rc.conf OtherEssentialFiles/global/home/.config/ranger/rifle.conf OtherEssentialFiles/global/home/.config/ranger/scope.sh trash.sh trash-size.sh)
command -v tmux &> /dev/null || command -v screen &> /dev/null && filelist+=(tmux_or_screen.sh OtherEssentialFiles/global/home/.tmux.conf)
command -v nvim &> /dev/null && filelist+=(OtherEssentialFiles/global/home/.config/nvim/init.vim)
command -v zsh &> /dev/null && filelist+=(OtherEssentialFiles/global/home/.zshrc OtherEssentialFiles/global/home/.zkbd/zkbd)
command -v pacman &> /dev/null && filelist+=(install.arch.sh OtherEssentialFiles/global/etc/pacman.conf OtherEssentialFiles/global/etc/pacman.d/mirrorlist)
command -v yay &> /dev/null && filelist+=(OtherEssentialFiles/global/home/.config/yay/config.json)
# command -v  &> /dev/null && filelist+=()

[ -z $authkeys ] && read -p "ssh authorized_keys? (y/n) " -n 1 authkeys
echo
if [ "${authkeys,,}" = "y" ]
then
  filelist+=(
  OtherEssentialFiles/global/home/.ssh/authorized_keys
  newauth.sh
)
fi

[ -z $trust ] && read -p "Trusted machine? (y/n) " -n 1 trust
echo
if [ "${trust,,}" = "y" ]
then
  filelist+=(
  OtherEssentialFiles/global/home/.ssh/config
  OtherEssentialFiles/global/home/.ssh/config-home
  OtherEssentialFiles/global/home/.ssh/config-other
  OtherEssentialFiles/global/home/.unison/default.prf
  newsshconfig.sh
)
fi

for dotfile in ${filelist[@]}
do
  [ ! -d "$(dirname $HOME/Scripts/$dotfile)" ] && mkdir -p $(dirname $HOME/Scripts/$dotfile)
  curl http://sc.tralce.com/$dotfile -o $HOME/Scripts/$dotfile -f &> /dev/null && echo "Downloaded $dotfile"
done
chmod -Rc ug+rwx,o-w+rx $HOME/Scripts

[ -z $fixsym ] && read -p "Run fixsymlinks.sh -fu? (y/n) " -n 1 fixsym
echo
if [ "${fixsym,,}" = "y" ]
then
  ~/Scripts/fixsymlinks.sh -fus
fi

if [[ "${trust,,}" = "y" ]]
then
  if ! command -v unison &> /dev/null
  then
    read -p "Install unison? (y/n) " -n 1 inunis
    echo
    if [ "${inunis,,}" = "y" ]
    then
      if command -v pacman &> /dev/null
      then
        checkroot pacman -Syu --noconfirm unison-tralce
      else
        checkroot wget "https://s3.wasabisys.com/file-drops/archlinux/unison" -O /usr/bin/unison && chmod +x /usr/bin/unison
      fi
    fi
  fi
fi

[ -z $fixsudo ] && read -p "Run fixsudoers.sh -fu? (y/n) " -n 1 fixsudo
echo
if [ "${fixsudo,,}" = "y" ]
then
  ~/Scripts/fixsudoers.sh
fi

[[ -f $HOME/Scripts/OtherEssentialFiles/global/home/.ssh/authorized_keys ]] && [ -z $newauth ] && read -p "Run newauth.sh? (y/n) " -n 1 newauth
echo
if [ "${newauth,,}" = "y" ]
then
  ~/Scripts/newauth.sh -f
fi

[[ -f $HOME/Scripts/OtherEssentialFiles/global/home/.ssh/config ]] && [ -z $newssh ] && read -p "Run newsshconfig.sh? (y/n) " -n 1 newssh
echo
if [ "${newssh,,}" = "y" ]
then
  ~/Scripts/newsshconfig.sh -f
fi

