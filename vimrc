set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
Bundle 'command-t'
Bundle 'pbrisbin/vim-runfile'

syntax on

function! MapToggle(key, opt)
  let cmd = ':set '.a:opt.'! \| set '.a:opt."?\<CR>"
  exec 'nnoremap '.a:key.' '.cmd
  exec 'inoremap '.a:key." \<C-O>".cmd
endfunction

command! -nargs=+ MapToggle call MapToggle(<f-args>)

call togglebg#map("<F3>")
MapToggle <F4> foldenable
MapToggle <F5> number
MapToggle <F6> spell
MapToggle <F7> hlsearch
MapToggle <F8> paste
MapToggle <F9> wrap

" Switch to alternate file
map <C-k> <C-w><Up>
map <C-j> <C-w><Down>
map <C-l> <C-w><Right>
map <C-h> <C-w><Left>

let mapleader=","
let &colorcolumn=join(range(81,999),",")

set mouse=a
set tabstop=2
set shiftwidth=2
set expandtab 
set pastetoggle=<F8>
set number
set encoding=utf-8
set fileencoding=utf-8
set fileencodings="us-ascii:iso-8859-15:utf-8"
set spelllang=de
set cursorline
set hlsearch
set lazyredraw
set ttyfast
set nofoldenable

highlight Comment cterm=italic
filetype plugin indent on

if $TERM =~ "-256color"
  set t_Co=256
  colorscheme solarized
  set bg=dark
endif

if has("gui_running")
  set t_Co=256
"  colorscheme zenburn
  colorscheme solarized
  set bg=dark
  set guifont=Consolas\ 12
  set guioptions=em
endif


let g:runfile_by_type = {
    \ 'racket': '!racket %',
    \ 'html'    : '!chromium %',
    \ 'sage' : '!sage -t %'
    \ }

nnoremap         ,b   :CommandTBuffer<CR>


