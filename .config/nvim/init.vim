set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

if exists("g:neovide")
  let g:neovide_transparency=0.8
  set guifont=Fira\ Code:h11
endif

source ~/.vimrc
