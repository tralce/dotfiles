#!/bin/bash
[ -z ${2} ] && exit 1
vim +${2}d +wq $HOME/.ssh/known_hosts.${1}
