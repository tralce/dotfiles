#!/bin/bash
# vim:foldmethod=marker

bashrcver="v2021-09-14"

. $HOME/Scripts/src/src.sh
. $HOME/.bin/aliases_global.sh
[ -f $HOME/.aliases.sh ] && . $HOME/.aliases.sh

alias fuck='sudo $(fc -nl -1)'

[ -f /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -f /opt/local/etc/profile.d/bash_completion.sh ] && . /opt/local/etc/profile.d/bash_completion.sh

if which udisksctl &> /dev/null # {{{
then
  um() {
    [ -z $1 ] && return 1
    for fs in $*
    do
      udisksctl mount -b $fs
    done
  }
  uu() {
    [ -z $1 ] && return 1
    for fs in $*
    do
      udisksctl unmount -b $fs
    done
  }
fi # }}}

# path {{{
for newpath in \
  /usr/local/bin \
  /usr/bin \
  /bin \
  /usr/sbin \
  /sbin \
  $HOME/Scripts/OtherEssentialFiles/$(hostname -s)/scripts \
  $HOME/Scripts \
  $HOME/Scripts/former_functions \
  $HOME/Scripts/launchers \
  /var/lib/snapd/snap/bin \
  $HOME/.local/share/gem/ruby/3.0.0/bin \
  /home/linuxbrew/.linuxbrew/bin \
  ~/.local/bin \
  /usr/local/opt/coreutils/libexec/gnubin
do
  if [ -d "$newpath" ]
  then
    export PATH=$PATH:$newpath:
  fi
done
export PATH="$(echo $PATH|tr ':' '\n'|sed '/^$/d'|awk '!x[$0]++'|tr '\n' ':')"
# }}}

# editor {{{
if which nvim &> /dev/null
then
  export EDITOR=nvim
  export VISUAL=nvim
  alias vim="nvim"
  alias vimdiff="nvim -d"
elif which vim &> /dev/null
then
  export EDITOR=vim
  export VISUAL=vim
elif which micro &> /dev/null
then
  alias vim="micro"
  export EDITOR=micro
  export VISUAL=micro
else
  export EDITOR=nano
  export VISUAL=nano
fi
# }}}

# pager {{{
if which nvimpager &> /dev/null
then
  export PAGER="nvimpager"
elif which vimpager &> /dev/null
then
  export PAGER="vimpager"
else
  export LESS="-Rcsi"
  export PAGER="less -Rcsi"
  export LESS_TERMCAP_md=$'\e[01;31m'
  export LESS_TERMCAP_me=$'\e[0m'
  export LESS_TERMCAP_se=$'\e[0m'
  export LESS_TERMCAP_so=$'\e[01;44;33m'
  export LESS_TERMCAP_ue=$'\e[0m'
  export LESS_TERMCAP_us=$'\e[01;32m'
fi
# }}}

# ls {{{
if which lsd &> /dev/null
then
  alias ls="lsd"
  alias lst="lsd -lS --total-size"
elif which exa &> /dev/null
then
  alias ls="exa --group-directories-first"
fi # }}}

# shell options {{{
export HISTSIZE="32768" # biggest history possible
HISTCONTROL=ignoreboth
PROMPT_COMMAND='history -a' # immediately append to .bash_history
shopt -s checkwinsize # fix window size on resize
shopt -s histappend # append to .bash_history instead of overwriting
# }}}

# prompt {{{
rnglv=
if [ ! -z $RANGER_LEVEL ]
then
  rnglv="\[\e[33m\][$RANGER_LEVEL deep into ranger shells]\[\e[m\]\n"
fi
if [ $UID = 0 ]
then
  export PS1="$rnglv\[\e[31m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\] \[\e[31m\]\\$\[\e[m\] "
else
  export PS1="$rnglv\[\e[32m\]\u\[\e[m\]\[\e[36m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\] \[\e[32m\]\\$\[\e[m\] "
fi
# }}}

# tmux and splash {{{
if [[ $- =~ i ]]
then
  stty ixoff -ixon # disable C-s to pause
  stty ixany # any sequence can restart flow
  [ -f $HOME/Scripts/tmux_or_screen.sh ] && $HOME/Scripts/tmux_or_screen.sh
  echocolor cyan "$bashrcver on $(uname -srm) $(uptime -p 2> /dev/null || uptime)"
fi
# }}}
