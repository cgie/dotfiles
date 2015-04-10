set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()


Bundle 'gmarik/vundle'
Bundle 'altercation/vim-colors-solarized'
"Bundle 'wincent/Command-T'
"Bundle 'pbrisbin/vim-runfile'
Bundle 'bling/vim-airline'
Bundle 'tpope/vim-fugitive'
Bundle 'nickng/vim-scribble'
"Bundle 'kchmck/vim-coffee-script'
Bundle 'groenewege/vim-less'
"Bundle 'suan/vim-instant-markdown'
"Bundle 'aperezdc/vim-template'
"Bundle 'vim-scripts/brainfuck-syntax.git'
"Bundle 'jcfaria/Vim-R-plugin'
"Bundle 'ervandew/screen'
Bundle 'freitass/todo.txt-vim'


syntax on

let mapleader=" "
let maplocalleader=" "

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

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <silent><leader>h :set invhlsearch<CR>
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprev<CR>
nnoremap <leader>d :bdelete<CR>

let &colorcolumn=join(range(81,400),",")


set mouse=a
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
set cindent
set expandtab
set pastetoggle=<F8>
set number
set encoding=utf-8
set fileencoding=utf-8
set fileencodings="us-ascii:iso-8859-15:utf-8"
" requires vim-spell-de
set spelllang=de,en
set cursorline
set hlsearch
set lazyredraw
set ttyfast
set nofoldenable
set hidden
set ignorecase
set smartcase
set showcmd
set undofile
set undodir=/home/cgie/.vim/undo
set undolevels=1000
set undoreload=10000
set noswapfile

highlight Comment cterm=italic
filetype plugin indent on


if $TERM =~ "-256color"
  set t_Co=256
"  let &background = readfile('/home/cgie/.solarizedstatusforvim', '', 1)[0]
  set background=dark
  colorscheme solarized
endif

if has("gui_running")
  set t_Co=256
"  let &background = readfile('/home/cgie/.solarizedstatusforvim', '', 1)[0]
  colorscheme solarized
  set guifont=Inconsolata\ for\ Powerline\ 12
  set guioptions=e
endif


let g:runfile_by_type = {
    \ 'racket': '!racket %',
    \ 'html'    : '!chromium %',
    \ 'sage' : '!sage -t %'
    \ }

nnoremap         ,b   :CommandTBuffer<CR>

let g:airline_powerline_fonts = 1
let g:airline_theme = "solarized"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#fnamemod = ':t:r'
set laststatus=2

let g:LatexBox_quickfix=2

set ttimeoutlen=50

augroup vimrc
  autocmd!
  autocmd BufEnter *.md,*.mkd setlocal filetype=markdown
  autocmd FileType gitcommit setlocal spell
  autocmd FileType haskell setlocal shiftwidth=4 | let b:ctags_command = 'hs-ctags %f'
  autocmd FileType mail setlocal spell nohlsearch
  autocmd FileType markdown setlocal formatoptions+=twn nosmartindent spell nofoldenable
  autocmd FileType html setlocal noshowmatch
augroup END
