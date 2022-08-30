" vim:foldmethod=marker

" vim-plug {{{
silent! call plug#begin('~/.vim/plugged')
Plug 'norcalli/nvim-colorizer.lua'
" Plug 'gko/vim-coloresque'
Plug 'dag/vim-fish'
Plug 'dense-analysis/ale'
Plug 'dhruvasagar/vim-table-mode'
Plug 'jamessan/vim-gnupg'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'masukomi/vim-markdown-folding'
Plug 'mbbill/undotree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ralismark/opsort.vim'
Plug 'tralce/vim-airline-themes'
Plug 'tralce/vim-monokai'
Plug 'vim-airline/vim-airline'
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
call plug#end()
" }}}

" sets and settings {{{

" indent {{{
set autoindent
set expandtab
set shiftwidth=2
set tabstop=2
" }}}

" mouse {{{
set mouse=a
function! MouseToggle()
  if &mouse == "a"
    set mouse=
    echom "••• mouse off •••"
  else
    set mouse=a
    echom "••• mouse on •••"
  endif
endfunction
nnoremap <F6> :call MouseToggle()<CR>
noremap <LeftDrag> <LeftMouse>
noremap! <LeftDrag> <LeftMouse>
" }}}

" cursor - https://stackoverflow.com/questions/6488683/how-to-change-the-cursor-between-normal-and-insert-modes-in-vim
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

filetype plugin indent on
" highlight CursorLineNR ctermbg=red
highlight clear CursorLine
set autochdir
set backspace=indent,eol,start
set browsedir=buffer
set clipboard+=unnamedplus
set cursorline
set fillchars=fold:\  " no dots for folds
set modeline
set noshowmode
set nowrap
set omnifunc=syntaxcomplete#Complete
set scrolloff=999
set showcmd
set showmatch
set termguicolors
syntax on

if has("gui_running")
  set guioptions -=m
  set guioptions -=T
endif

" https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" }}}

" plugin settings {{{
if has("nvim")
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  lua require'colorizer'.setup()
endif

" vimwiki {{{
" let g:vimwiki_list = [{'path': '~/Documents/vw/', 'syntax': 'markdown', 'ext': '.md', 'listsyms': ' ○◐●✓'}]
let g:vimwiki_list = [{'path': '~/.vimwiki/', 'listsyms': ' ·○◐●✓'}]
let g:vimwiki_global_ext = 0
let g:vimwiki_folding = 'expr'
let vimwiki_hl_cb_checked = 2

autocmd FileType vimwiki set foldlevel=1
autocmd FileType vimwiki set foldenable
autocmd FileType vimwiki set foldmethod=expr
autocmd FileType vimwiki set foldexpr=VimwikiFoldLevelCustom(v:lnum)
autocmd FileType vimwiki IndentGuidesDisable

hi VimwikiHeader1 cterm=bold gui=bold guifg=#FA8419
hi VimwikiHeader2 cterm=bold gui=bold guifg=#9C64FE
hi VimwikiHeader3 cterm=bold gui=bold guifg=#66d9ef
hi VimwikiHeader4 cterm=bold gui=bold guifg=#FFFF43
hi VimwikiHeader5 cterm=bold gui=bold guifg=#97E023
hi VimwikiHeader6 cterm=bold gui=bold guifg=#FF1919

hi VimwikiLink cterm=underline gui=underline guifg=#4377FE
hi textSnipTEX cterm=bold gui=bold guifg=#FF0055

  function! VimwikiLinkHandler(link)
    " Use Vim to open external files with the 'vfile:' scheme.  E.g.:
    "   1) [[vfile:~/Code/PythonProject/abc123.py]]
    "   2) [[vfile:./|Wiki Home]]
    let link = a:link
    if link =~# '^vfile:'
      let link = link[1:]
    else
      return 0
    endif
    let link_infos = vimwiki#base#resolve_link(link)
    if link_infos.filename == ''
      echomsg 'Vimwiki Error: Unable to resolve link!'
      return 0
    else
      exe 'tabnew ' . fnameescape(link_infos.filename)
      return 1
    endif
  endfunction

function! VimwikiFoldLevelCustom(lnum) " {{{
  let pounds = strlen(matchstr(getline(a:lnum), '^#\+'))
  if (pounds)
    return '>' . pounds  " start a fold level
  endif
  if getline(a:lnum) =~? '\v^\s*$'
    if (strlen(matchstr(getline(a:lnum + 1), '^#\+')))
      return '-1' " don't fold last blank line before header
    endif
  endif
  return '=' " return previous fold level
endfunction " }}}
" }}}

" airline
let g:airline_theme='distinguished'

" fish
autocmd FileType fish compiler fish

" indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 1

" gpg
let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='

" monokai
let g:monokai_term_italic = 1
let g:monokai_gui_italic = 1

" undotree
nnoremap <F5> :UndotreeToggle<CR>
map <leader>ut :UndotreeToggle<CR>

" fzf.vim
nmap <leader>rg :Rg<cr>
nmap <leader>fs :Files<cr>
" }}}

" backup, swap, and undo {{{
silent !mkdir /tmp/vim &> /dev/null
" backup {{{
set backupdir=/tmp/vim/backup//
if !isdirectory(&backupdir)
  call mkdir(&backupdir)
endif
set backupcopy=yes
set backup
" }}}
" swap {{{
set directory=/tmp/vim/swap//
if !isdirectory(&directory)
  call mkdir(&directory)
endif
" }}}
" undo {{{
set undodir=/tmp/vim/undo//
if !isdirectory(&undodir)
  call mkdir(&undodir)
endif
set undofile
" }}}
" }}}

" commands {{{
command! W w
command! Q q
command! Wq wq
command! WQ wq
command! Wa wa
command! WA wa
command! Wqa wqa
command! Cls  :let @/ = ""
command! Comp g/\[X\]\|\[-\]\| ✓ \|[✓]/m$|:Cls
command! Uncomp %s/\[.\]\|\[o\]\|\[O\]\|\[X\]\|\[-\]/\[ \]/g|:Cls
command! Std  s/ /-/g|:Cls
command! Relo :so ~/.vimrc
" }}}

" maps {{{
nnoremap coc r✓
nnoremap cod r•
nnoremap cot r·
nnoremap coD r‡
noremap <Leader>q q
map <leader>ss :set spell!<CR>
map Y y$
map q :quit<CR>
map zb :set foldlevel=1<CR>
nmap ; :
nnoremap N Nzz
nnoremap Q q
nnoremap n nzz
" }}}

colorscheme monokai
