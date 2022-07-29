#!/bin/bash
# vim:fdm=marker

# [ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

source ~/Scripts/src/src.sh

if [ -d "$HOME/Documents/Backups" ]
then
  backupdir="$HOME/Documents/Backups/essential_backup.sh/$(hostname -s)-$(date +%Y-%m-%d)"
else
  backupdir="$HOME/essential_backup.sh-$(hostname -s)-$(date +%Y-%m-%d)"
fi

[ ! -d "$backupdir" ] && mkdir -p "$backupdir"

backupcron() { # {{{
  echocolor green "Backing up crontabs..."
  if [ -d "/var/spool/cron/crontabs" ]
  then
    mkdir -p $backupdir/cron/
    checkroot cp -rv /var/spool/cron/crontabs/* $backupdir/cron/
    checkroot chown -R $(whoami) $backupdir/cron/
    chmod -R ug+rwx,o-w+rx $backupdir/
  elif [ -d "/var/spool/cron/" ]
  then
    mkdir -p $backupdir/cron/
    checkroot cp -rv /var/spool/cron/* $backupdir/cron/
    checkroot chown -R $(whoami) $backupdir/cron/
    chmod -R ug+rwx,o-w+rx $backupdir/
  else
    echocolor red "Couldn't find crontabs in the usual places."
  fi
} # }}}

backupsystemd-boot() { # {{{
  echocolor green "Backing up systemd-boot..."
  mkdir -p $backupdir/systemd-boot
  cp -r /boot/loader/loader.conf /boot/loader/entries $backupdir/systemd-boot/
  chmod -R ug+rwx,o-w+rx $backupdir/
} # }}}

backupgrub() { # {{{
  echocolor green "Backing up grub..."
  mkdir -p $backupdir/grub
  cp -r /boot/grub/grub.cfg /etc/default/grub $backupdir/grub/
  chmod -R ug+rwx,o-w+rx $backupdir/
} # }}}

backupshellhist() {
  echocolor green "Backing up shell histories..."
  mkdir -p $backupdir/hist
  [ -e $HOME/.bash_history ] && cp $HOME/.bash_history $backupdir/hist/bash_history
  [ -e $HOME/.histfile ] && cp $HOME/.histfile $backupdir/hist/zsh_history
  [ -e $HOME/.local/share/fish/fish_history ] && cp $HOME/.local/share/fish/fish_history $backupdir/hist/fish_history
  chmod -R ug+rwx,o-w+rx $backupdir/
}

backupsyslinux() { # {{{
  echocolor green "Backing up syslinux..."
  mkdir -p $backupdir/syslinux
  cp -r /boot/syslinux/syslinux.cfg $backupdir/syslinux/
  chmod -R ug+rwx,o-w+rx $backupdir/
} # }}}

backupfstab() { # {{{
  echocolor green "Backing up fstab..."
  mkdir -p $backupdir/
  cat /etc/fstab |tee $backupdir/fstab-$(date +%Y.%m.%d)
  chmod -R ug+rwx,o-w+rx $backupdir/
} # }}}

backupssh() { # {{{
  echocolor green "Backing up ssh..."
  mkdir -p $backupdir/ssh-etc/
  mkdir -p $backupdir/ssh-home/
  checkroot cp -v /etc/ssh/ssh* $backupdir/ssh-etc/
  cp -v $HOME/.ssh/* $backupdir/ssh-home/
  checkroot chown -R $(whoami) $backupdir/ssh-etc/
  chmod -R ug+rwx,o-w+rx $backupdir/
} # }}}

essential_backup() { # {{{
  which crontab &> /dev/null && backupcron
  test -e /boot/loader &>/dev/null && backupsystemd-boot
  test -e /boot/grub &> /dev/null && backupgrub
  test -e /boot/syslinux &> /dev/null && backupsyslinux
  backupfstab
  backupssh
  backupshellhist
} # }}}

essential_backup

