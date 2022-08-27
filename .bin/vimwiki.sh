#!/bin/bash

fail() {
  echo "$@"
  exit 1
}

test -d ~/.vimwiki || fail "Can't stat ~/.vimwiki"

if which nvim &> /dev/null
then
  EDITOR=nvim
elif which vim
then
  EDITOR=vim
else
  fail "Did not find vim or neovim."
fi

pushd ~/.vimwiki

if git pull
then
  $EDITOR +VimwikiIndex
  git add -A ~/.vimwiki
  git commit -m $(uuidgen)
  git push
else
  gum confirm "Couldn't 'git pull'; open read only?" && $EDITOR -R +VimwikiIndex || fail "Canceled."
fi
