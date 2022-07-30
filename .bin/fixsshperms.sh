#!/bin/bash
chmod -Rc a-xst+X,u+rw,go-rwx ~/.ssh/
#chown -Rc $(id -un):$(id -gn) $HOME/.ssh
#chmod -Rc ug-s $HOME/.ssh
#chmod -c 755 $HOME/.ssh
#chmod -c 600 .ssh/*
#
#[ -f $HOME/.ssh/authorized_keys ] && chmod -c 600 $HOME/.ssh/authorized_keys
#[ -f $HOME/.ssh/config ] && chmod -c 600 $HOME/.ssh/config
#[ -f $HOME/.ssh/id_rsa ] && chmod -c 600 $HOME/.ssh/id_rsa
#[ -f $HOME/.ssh/id_rsa.pub ] && chmod -c 644 $HOME/.ssh/id_rsa.pub
#chmod -c 600 $HOME/.ssh/known_hosts*
#chmod -c 600 $HOME/.ssh/*.pem 2> /dev/null || exit 0
