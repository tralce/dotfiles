alias backup="echo 'this is not nas - ssh in and run backup'"
alias chgrp="chgrp -c"
alias chmod="chmod -c"
alias chown="chown -c"
alias cp="cp -v"
alias dmesg="checkroot dmesg -T"
alias fixsshperms="chmod -Rc a-xst+X,u+rw,go-rwx ~/.ssh/"
alias fixsynergy="pkill synergy;sleep 1;synergyc 172.21.2.3"
alias grep="grep --color=auto"
alias ip="ip -c"
alias ipinfo="curl ipinfo.io"
alias ipq="ip -br"
alias lsblk="lsblk -o NAME,SIZE,FSAVAIL,FSUSE%,FSTYPE,MOUNTPOINT,LABEL"
alias minimal='bash -c "$(curl http://sc.tralce.com/minimal.sh)"'
alias mv="mv -v"
alias nossh="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
alias nosshnokey="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=yes -o PreferredAuthentications=keyboard-interactive,password -o PubkeyAuthentication=no"
alias poweroff="checkroot poweroff"
alias reboot="checkroot reboot"
alias rename="rename -v"
alias resetperms="chmod -R a-x+X,ug+rw,o-w+r"
alias shred="shred -vun50"
alias sync_size="watch grep -e Dirty: -e Writeback: /proc/meminfo"
alias sysyadm="sudo yadm --yadm-dir /etc/yadm --yadm-data /etc/yadm/data"
alias tmx="tmux_or_screen.sh"
alias updatedb="checkroot updatedb"
alias vupd="vim +PlugInstall +PlugUpdate! +PlugUpgrade +PlugClean +qa"
alias vw="vim -c WikiIndex"
alias wasabi="aws --profile wasabi --endpoint-url=https://s3.wasabisys.com s3"
alias wasabidgc="aws --profile wasabi-dgc --endpoint-url=https://s3.wasabisys.com s3"
test -f /etc/issue && alias piversion="grep -q Revision /proc/cpuinfo && curl -L perturb.org/rpi?rev=$(awk '/^Revision/ { print $3 }' /proc/cpuinfo)"
test -f ~/.acme.sh/acme.sh && alias acme.sh="~/.acme.sh/acme.sh"
test -f ~/topgrade && alias topgrade="~/topgrade"
