#!/usr/bin/env fish
# vim:foldmethod=marker

set -l configver v2021-09-14

# colors {{{
set -U fish_color_autosuggestion brgrey
set -U fish_color_cancel brred
set -U fish_color_command brgreen
set -U fish_color_comment brgrey
set -U fish_color_cwd brblue
set -U fish_color_end brmagenta
set -U fish_color_error brred
set -U fish_color_escape brred
set -U fish_color_host brgreen
set -U fish_color_host_remote red
set -U fish_color_keyword brmagenta
set -U fish_color_match brred --background brblack
set -U fish_color_normal brwhite
set -U fish_color_operator brmagenta
set -U fish_color_param cyan
set -U fish_color_quote yellow
set -U fish_color_redirection brmagenta
set -U fish_color_search_match --background=grey
set -U fish_color_user brgreen
set -U fish_color_valid_path brblue --underline
set -U fish_pager_color_completion normal
set -U fish_pager_color_description yellow
set -U fish_pager_color_prefix white --bold --underline
set -U fish_pager_color_progress brmagenta --background=grey

# idk what these do
set -U fish_color_history_current brblue
set -U fish_color_selection white --bold --background=brblack
# }}}

# fish_prompt {{{
function fish_prompt --description 'Write out the prompt'
  set -l last_pipestatus $pipestatus
  set -l last_status $status
  set -l normal (set_color normal)
  set -l color_user $fish_color_user
  set -l color_host $fish_color_host
  set -l prefix
  set -l suffix ' ξ'
  if contains -- $USER root toor
    set color_user brred
    set suffix ' #'
  end
  if set -q SSH_TTY
    set color_host $fish_color_host_remote
  end
  set -l prompt_status (__fish_print_pipestatus " [" "]" "|" (set_color $fish_color_status) (set_color --bold $fish_color_status) $last_pipestatus)
  if set -q RANGER_LEVEL
    set rngstatus "[$RANGER_LEVEL deep into ranger shells]\n"
  else
    set rngstatus
  end
  echo -e -n -s (set_color bryellow) $rngstatus (set_color $color_user) "$USER" (set_color brblue) @ (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $fish_color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal $prompt_status (set_color $color_user) $suffix $normal" "
end
# }}}

# Environment Variables etc {{{
# nnn {{{
if which nnn &> /dev/null
  alias nnn="nnn -P p"
  set -x O_ICONS 1
  set -x NNN_BMS "L:~/SourceSoftware/LinuxStuff/arch;S:~/.bin"
  set -x NNN_TRASH 1
  set -x NNN_COLORS 4321
  set -x NNN_PLUG 'p:preview-tui;f:finder;d:diffs;i:ipinfo;o:oldbigfilei;u:_ncdu $nnn*;O:organize;x:_aunpack $nnn'
  set -x NNN_OPTS "edRu"
  set -x NNN_FIFO "$HOME/.config/nnn/nnn.fifo"
  set -x USE_PISTOL 0
  set -x USE_SCOPE 0
end # }}}
# path {{{
for newpath in \
  /usr/local/bin \
  /usr/bin \
  /bin \
  /usr/sbin \
  /sbin \
  $HOME/.bin-trust \
  $HOME/.bin-local \
  $HOME/.bin \
  /var/lib/snapd/snap/bin \
  /usr/local/opt/coreutils/libexec/gnubin \
  $HOME/.local/share/gem/ruby/3.0.0/bin \
  $HOME/.local/bin \
  /home/linuxbrew/.linuxbrew/bin
  if test -d $newpath
    fish_add_path -am $newpath
  end
end
#$HOME/.bin/OtherEssentialFiles/path.sh|while read pathdir
#  if not contains $pathdir $PATH
#    set -g PATH $PATH $pathdir
#  end
#end
# }}}
# editor {{{
if which vim &> /dev/null
  set -x EDITOR vim
  set -x VISUAL vim
else if which nvim &> /dev/null
  function vim --wraps=nvim --description 'alias vim=nvim'
    nvim $argv;
  end
  function vimdiff --wraps='nvim -d' --description 'alias vimdiff=nvim -d'
    nvim -d $argv;
  end
  set -x EDITOR nvim
  set -x VISUAL nvim
else if which micro &> /dev/null
  set -x EDITOR micro
  set -x VISUAL micro
else
  set -x EDITOR nano
  set -x VISUAL nano
end # }}}
# lsd {{{
if which lsd &> /dev/null
  alias ls="lsd"
  alias lst="lsd -lS --total-size"
end # }}}
# pager {{{
if which nvimpager &> /dev/null
  set -x PAGER nvimpager
else if which vimpager &> /dev/null
  set -x PAGER vimpager
else
  set -x LESS "-Rcsi"
  set -x PAGER "less -Rcsi"
  set -x LESS_TERMCAP_mb (printf "\033[01;31m")
  set -x LESS_TERMCAP_md (printf "\033[01;31m")
  set -x LESS_TERMCAP_me (printf "\033[0m")
  set -x LESS_TERMCAP_se (printf "\033[0m")
  set -x LESS_TERMCAP_so (printf "\033[01;44;33m")
  set -x LESS_TERMCAP_ue (printf "\033[0m")
  set -x LESS_TERMCAP_us (printf "\033[01;32m")
end
# }}}

set -x GPG_TTY (tty)
# }}}

# Uncategorized Functions {{{
if which udisksctl &> /dev/null # {{{
  function um
    for fs in $argv
      udisksctl mount -b $fs
    end
  end
  function uu
    for fs in $argv
      udisksctl unmount -b $fs
    end
  end
end # }}}
function echocolor # {{{
  set_color "$argv[1]";echo -e "$argv[2..-1]";set_color normal
end
# }}}
function checkroot # {{{
  if test (id -u) -eq 0
    $argv
  else
    sudo $argv
  end
end
# }}}
function resolve_command # {{{
    set -l token (commandline -t)
    commandline -rt -- (command -s -- $token)
end

bind \cg resolve_command # }}}
# }}}

# Aliases {{{
  alias fuck='eval sudo $history[1]'

test -e $HOME/.bin/aliases-global.sh;and source $HOME/.bin/aliases-global.sh

test -e $HOME/.bin-local/aliases-local.sh;and source $HOME/.bin-local/aliases-local.sh
test -e $HOME/.bin-trust/aliases-trust.sh;and source $HOME/.bin-trust/aliases-trust.sh
# }}}

# tmux and splash {{{
status is-interactive;and test "$TERM != linux";and test -n "$SSH_CLIENT";and ~/.bin/tmux_or_screen.sh

set fish_greeting (set_color ff0055)$configver on $(uname -srm 2> /dev/null ) $(uptime -p 2> /dev/null || uptime) \(fish\)
# }}}
