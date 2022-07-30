" vim:foldmethod=marker

" vim-plug {{{
silent! call plug#begin('~/.vim/plugged')
Plug 'dag/vim-fish'
Plug 'dense-analysis/ale'
Plug 'dhruvasagar/vim-table-mode'
Plug 'dkarter/bullets.vim'
Plug 'godlygeek/tabular'
Plug 'jamessan/vim-gnupg'
Plug 'lervag/wiki-ft.vim'
Plug 'lervag/wiki.vim'
Plug 'masukomi/vim-markdown-folding'
Plug 'mbbill/undotree'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'ntpeters/vim-better-whitespace'
Plug 'raimondi/delimitmate'
Plug 'ralismark/opsort.vim'
Plug 'tpope/vim-eunuch'
Plug 'tralce/vim-airline-themes'
Plug 'tralce/vim-monokai'
Plug 'vim-airline/vim-airline'
call plug#end()
" }}}

" sets and settings {{{
" indent {{{
set autoindent
set expandtab
set shiftwidth=2
"set smartindent
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
filetype plugin indent on
highlight CursorLineNR ctermbg=red
highlight clear CursorLine
set backspace=indent,eol,start
set clipboard+=unnamedplus
set cursorline
set termguicolors
set browsedir=buffer
set modeline
set noshowmode
set nowrap
set omnifunc=syntaxcomplete#Complete
set scrolloff=999
set showcmd
set showmatch
syntax enable

if has("gui_running")
  set guioptions -=m
  set guioptions -=T
endif
" }}}

" plugin settings {{{
if has("nvim")
" indent guides {{{
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_start_level = 1
  let g:indent_guides_guide_size = 1
" }}}
  set fillchars=fold:\ ,eob:~
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  lua require'colorizer'.setup()
endif

" table-mode
let g:table_mode_color_cells = 1
nmap gqq :TableModeRealign<CR>

" airline
let g:airline_theme='distinguished'

" fish
autocmd FileType fish compiler fish

" startify
let g:startify_bookmarks = [ {'v': '~/.vimrc'}, {'f': '~/.config/fish/config.fish'}, {'a': '~/.config/awesome/rc.lua'} ]

" gpg
let g:GPGFilePattern = '*.\(gpg\|asc\|pgp\)\(.wiki\)\='

" bullets
let g:bullets_enabled_file_types = ['markdown', 'wiki']
nmap <C-Space> :ToggleCheckbox<CR>

" wiki.vim
let g:wiki_root = '~/Documents/vw'
autocmd FileType wiki set foldlevel=1
autocmd FileType wiki IndentGuidesDisable

" monokai
let g:monokai_term_italic = 1
let g:monokai_gui_italic = 1

" undotree
nnoremap <F5> :UndotreeToggle<CR>
map <leader>ut :UndotreeToggle<CR>

" }}}

" backup, swap, and undo {{{
" backup {{{
silent !mkdir $HOME/.vimtemp &> /dev/null
set backupdir=$HOME/.vimtemp/backup//
if !isdirectory(&backupdir)
  call mkdir(&backupdir)
endif
set backupcopy=yes
set backup
" }}}
" swap {{{
set directory=$HOME/.vimtemp/swap//
if !isdirectory(&directory)
  call mkdir(&directory)
endif
" }}}
" undo {{{
set undodir=$HOME/.vimtemp/undo//
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
command! Cls  :let @/ = ""
command! Comp g/\[X\]\|\[-\]\| ✓ /m$|:Cls
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
