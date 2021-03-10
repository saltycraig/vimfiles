" vim: fdm=indent nowrap ft=vim et sts=2 ts=2 sw=2
" vimrc for 8.2+
" Windows GVim => c:/users/cmaceachern/vimfiles/vimrc
" UNIX => ~/.vim/vimrc

" Bare-basics.
set nocompatible
filetype plugin on " enable loading plugin/foo.vim files for all filetypes
filetype indent on " enable loading indent/foo.vim files for all filetypes
syntax on
scriptencoding utf-8
set encoding=utf-8
let mapleader=' '

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'arcticicestudio/nord-vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
call plug#end()

" Plugin Settings

" Settings
set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set clipboard=unnamed,unnamedplus
set completeopt=menuone,popup
set hidden
set history=200
set hlsearch

set incsearch
set laststatus=2
set listchars=eol:$,space:·,
set modeline
set mouse=a
set noswapfile
set nrformats-=octal
set number
set path-=/usr/include
set path+=**10
set relativenumber
set ruler
set scrolloff=5
set showcmd
set showmatch
set showmode

set smartcase
set tags=./tags;,tags;
set termguicolors
set ttimeout
set ttimeoutlen=100
set wildignore=*/.git/*,*/.hg/*,*/.svn/*,*/.node_modules/*,*.o,*.obj
set wildmenu
set wildmode=list:longest,longest:full

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15
let g:netrw_list_hide=netrw_gitignore#Hide() . '.*\.swp$'

" Don't use Ex mode, use Q for formatting instead.
map Q gq
" Re-select visually selected area after indenting/dedenting.
xmap < <gv
xmap > >gv
" Move visual selection up/down lines.
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
" '%%' in command-line mode maybe expands to path of current buffer.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

nnoremap <F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <F4> :call utils#ToggleLocationList()<CR>
nnoremap <F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
" nnoremap <F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>

nnoremap <Leader>w :update<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>t :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>

nnoremap <Leader>l :buffer #<CR>
nnoremap <Leader>n :nohl<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>o :CtrlPTag<CR>
nnoremap <C-s> :source %<CR>

" Terminal

tnoremap <C-v><Esc> <Esc>

if has('mac') && has('gui_running')
  " macvim GUI
  set macmeta
  nnoremap ê <C-w>p<C-e><C-w>p
  nnoremap ë <C-w>p<C-y><C-w>p
  nnoremap Ê <C-w>p<C-d><C-w>p
  nnoremap Ë <C-w>p<C-u><C-w>p
elseif has('mac')
  " Alacritty, usually.
  nnoremap ∆ <C-w>p<C-e><C-w>p
  nnoremap ˚ <C-w>p<C-y><C-w>p
  nnoremap Ô <C-w>p<C-d><C-w>p
  nnoremap <C-w>p<C-u><C-w>p
elseif has('win64') && has('gui_running')
  " gVim 64-bit: 'win32' also returns 1
  nnoremap ê <C-w>p<C-e><C-w>p
  nnoremap ë <C-w>p<C-y><C-w>p
  nnoremap Ê <C-w>p<C-d><C-w>p
  nnoremap Ë <C-w>p<C-u><C-w>p
elseif !has('gui') && !has('gui_running')
  " Use Esc (^[) for terminal emulators for Alt support, e.g.
  " bash-for-windows/mintty terminal
  nnoremap j <C-w>p<C-e><C-w>p
  nnoremap k <C-w>p<C-y><C-w>p
  nnoremap J <C-w>p<C-d><C-w>p
  nnoremap K <C-w>p<C-u><C-w>p
endif

augroup vimrc
  autocmd!
augroup END

" Textfiles, vimrc files
autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal complete+=k
autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal tw=78
autocmd vimrc BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
if has('win64')
  autocmd vimrc BufWritePost ~/vimfiles/vimrc source ~/vimfiles/vimrc
else
  autocmd vimrc BufWritePost ~/.vim/vimrc source ~/.vim/vimrc
endif

" Quickfix/Location List
autocmd vimrc FileType * if &ft ==# 'qf' | setlocal nonu nornu | endif
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost  l* lwindow
autocmd vimrc VimEnter * cwindow
if (v:version >=# 802)
  packadd! cfilter
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message (it's
" likely a different one than last time).
autocmd vimrc BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
autocmd vimrc BufNewFile,BufRead *.patch set filetype=diff

" Remember the positions in files with some git-specific exceptions.
autocmd vimrc BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$")
  \           && &filetype !~# 'commit\|gitrebase'
  \           && expand("%") !~ "ADD_EDIT.patch"
  \           && expand("%") !~ "addp-hunk-edit.diff" |
  \   exe "normal g`\"" |
  \ endif

" Getting Help Easier
nnoremap <F1>f :help list-functions<CR>
nnoremap <F1>k :help keycodes<CR>
command! Api :help list-functions<CR>

command! Cd :cd %:h
command! TodoLocal :botright lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Only :.+,$bwipeout<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig"
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

set background=dark
colorscheme nord

