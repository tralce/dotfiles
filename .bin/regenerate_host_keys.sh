#!/bin/bash

fail() {
  echo "$*"
  exit 1
}

[ "$UID" -ne 0 ] && fail "Have to be root"

read -p "Are you absolutely sure? (y/n )" -n 1 choice
if [ "${choice,,}" = "y" ]
then
  rm -v /etc/ssh/ssh_host_*
  ssh-keygen -A
  systemctl restart sshd
else
  fail "User changed their mind."
fi
