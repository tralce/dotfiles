#!/bin/zsh
# vim:fdm=marker

zshrcver="v2021-09-14"

source $HOME/.bin/src.sh
source $HOME/.bin/aliases-global.sh
source ~/.zkbd/zkbd
[ -f $HOME/.bin-local/aliases-local.sh ] && . $HOME/.bin-local/aliases-local.sh

# completion {{{
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**'
# zstyle :compinstall filename '/home/tralce/.zshrc'
# }}}

autoload -U \
  compinit \
  promptinit \
  colors \
  edit-command-line \
  bashcompinit \
  zkbd \
  up-line-or-beginning-search \
  down-line-or-beginning-search
compinit -u # start completion without checking insecure dirs
bashcompinit
promptinit
colors

alias fuck='sudo $(fc -nl -1)'

zle -N edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

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
# lsd {{{
if which lsd &> /dev/null
then
  alias ls="lsd"
  alias lst="lsd -lS --total-size"
fi # }}}
# path {{{
for newpath in \
  /usr/local/bin \
  /usr/bin \
  /bin \
  /usr/sbin \
  /sbin \
  $HOME/.bin-local \
  $HOME/.bin-local \
  $HOME/.bin \
  /var/lib/snapd/snap/bin \
  /usr/local/opt/coreutils/libexec/gnubin \
  $HOME/.local/share/gem/ruby/3.0.0/bin \
  $HOME/.local/bin \
  /home/linuxbrew/.linuxbrew/bin
do
  if [ -d "$newpath" ]
  then
    [[ $PATH =~ $newpath: ]] || export PATH=$PATH:$newpath:
  fi
done
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

setopt COMPLETE_ALIASES
setopt CORRECT
setopt EXTENDED_GLOB
setopt HIST_IGNORE_ALL_DUPS
setopt NOMATCH
setopt NOTIFY
setopt NO_AUTO_CD
setopt NO_BEEP
setopt RC_EXPAND_PARAM
setopt SHARE_HISTORY

HISTFILE=$HOME/.histfile
HISTSIZE=10000
SAVEHIST=1000000

[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [ -f "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" ]
  then
    source "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
    bindkey '^[OA' history-substring-search-up
    bindkey '^[OB' history-substring-search-down
fi

[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
# prompt {{{
if [ -n "$RANGER_LEVEL" ]
then
  rngstatus="%F{yellow}[$RANGER_LEVEL deep into ranger shells]%{$reset_color%}
"
else
  rngstatus=""
fi

if [[ "$UID" == "0" ]]
then
  strcolor="red"
else
  strcolor="green"
fi
local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%} %s)"
PROMPT="${rngstatus}%F{$strcolor}%n%F{cyan}@%F{green}%m%F{blue} %~ ${ret_status}%# %{$reset_color%}"
# }}}

# tmux and splash {{{
if [[ $- =~ i ]]
then
  [ -f $HOME/Scripts/tmux_or_screen.sh ] && $HOME/Scripts/tmux_or_screen.sh
  echocolor cyan "$zshrcver on $(uname -srm) $(uptime -p 2> /dev/null || uptime)"
fi
# }}}

