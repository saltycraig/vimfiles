" vim: fdm=marker nowrap ft=vim et sts=2 ts=2 sw=2 fdl=0

" Plug {{{

let vimplug_exists=expand('~/.vim/autoload/plug.vim')
if has('win32') && !has('win64')
  let curl_exists=expand('C:\Windows\Sysnative\curl.exe')
else
  let curl_exists=expand('curl')
endif

if !filereadable(vimplug_exists)
  if !executable(curl_exists)
    echoerr 'You have to install curl or first install vim-plug yourself!'
    execute 'q!'
  endif
  echo 'Installing vim-plug into ~/.vim/autoload/plug.vim'
  echo ''
  silent exec '!'curl_exists' -fLo ' . shellescape(vimplug_exists) . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  let g:not_finish_vimplug = 'yes'
  autocmd init VimEnter * PlugInstall
endif

call plug#begin(expand('~/.vim/plugged'))
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'romainl/Apprentice'
Plug 'tpope/vim-fugitive'

call plug#end()

" }}}

" Bare-basics {{{
filetype plugin on " enable loading plugin/foo.vim files for all filetypes
filetype indent on " enable loading indent/foo.vim files for all filetypes
syntax on
set encoding=utf-8
scriptencoding utf-8
let mapleader=' '
" }}}

" Settings {{{
set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set clipboard=unnamed,unnamedplus
" Another option:
" set completeopt=menuone,noinsert,noselect,popup
set completeopt=menuone,popup
set cursorline
set foldlevelstart=99
set hidden
set history=200
set hlsearch
if executable('rg')
  set grepprg=rg\ --vimgrep
elseif executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif
set incsearch
set laststatus=2
set listchars=eol:$,space:·,
set modeline
set mouse=a
set noswapfile
set nrformats-=octal
set number
set omnifunc=syntaxcomplete#Complete
set path-=/usr/include
set path+=**10
set relativenumber
set ruler
set scrolloff=2
set showcmd
set showmatch
set showmode
set termguicolors
set ignorecase smartcase
set tags=./tags;,tags;
set thesaurus=~/.vim/thesaurus/english.txt
set ttimeout
set ttimeoutlen=100
set undofile undodir=~/.vim/undodir
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.node_modules/*
set wildignore+=*.o,*.obj,*.exe,*.bin,*.zip
set wildignore+=*.bmp,*.jpg,*.jpeg,*.svg,*.png
set wildmenu
" set wildmode=list:longest,longest:full

let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15
let g:netrw_list_hide=netrw_gitignore#Hide() . '.*\.swp$'

" enable use of folding with ft-markdown-plugin
let g:markdown_folding = 1

" enable :Man command and use it's folding
runtime ftplugin/man.vim
let g:ft_man_folding_enable=1

" I don't use these. Negligible cost to load but don't need them.
let g:loaded_gzip=1
let g:loaded_getscriptPlugin=1
let g:loaded_vimballPlugin=1
let g:loaded_logiPat=1
let g:loaded_rrhelper=1
let g:loaded_spellfile_plugin=1
let g:loaded_tarPlugin=1
let g:loaded_2html_plugin=1
let g:loaded_zipPlugin=1

" Feature/Version detection
if (v:version >=# 802)
  packadd! cfilter
endif

set background=dark
colorscheme apprentice
" }}}

" Mappings {{{
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
"cnoremap :wq :xall
"cnoremap :write :update

" Function keys
nnoremap <F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <F4> :call utils#ToggleLocationList()<CR>
nnoremap <F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
nnoremap <F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>
" iterm
nnoremap ê <C-w>p<C-e><C-w>p
nnoremap ë <C-w>p<C-y><C-w>p
nnoremap Ê <C-w>p<C-d><C-w>p
nnoremap Ë <C-w>p<C-u><C-w>p
" Leader keys
nnoremap <Leader>w :update<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>t :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
nnoremap <Leader>n :<C-u>nohl<CR>
nnoremap <Leader><Leader> :b #<CR>
nnoremap <Leader>/ :grep<Space>
nnoremap gh :diffget //2<CR>
nnoremap gl :diffget //3<CR>
tnoremap <C-v><Esc> <Esc>

" use <C-z> as wild character in mappings, because we can't use <Tab>
" set wildcharm=<C-z>
" nnoremap <Leader>e :edit <C-z><C-z>
" nnoremap <Leader>E :split <C-z><S-Tab>
" nnoremap <Leader>v :vsplit <C-z><S-Tab>
" nnoremap <Leader>f :find **/*<C-z><S-Tab>
 
" Getting Help Easier
nnoremap <F1>f :help list-functions<CR>
nnoremap <F1>k :help keycodes<CR>
nnoremap <F1><F1> :help<CR>
nnoremap <F1>m :help user-manual<CR>

inoreabbrev (<CR> (<CR>)<Esc>O
inoreabbrev ({<CR> ({<CR>});<Esc>O
inoreabbrev {<CR> {<CR>}<Esc>O
inoreabbrev {; {<CR>};<Esc>O
inoreabbrev {, {<CR>},<Esc>O
inoreabbrev [<CR> [<CR>]<Esc>O
inoreabbrev [; [<CR>];<Esc>O
inoreabbrev [, [<CR>],<Esc>O
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" fugitive
nnoremap <Leader>g :G<CR>
nnoremap <Leader>gP :G push<CR>

" }}}

" Commands {{{

cnoremap grep Grep
command! -nargs=+ -bar Grep :silent! grep! <args>|redraw!
command! Api :help list-functions<CR>
command! Cd :cd %:h
command! TodoLocal :botright lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Only :.+,$bwipeout<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig"
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

" Runs a vim command into a scratch buffer
function! Scratchify(cmd)
  redir => message
  silent execute a:cmd
  redir END
  if empty(message)
    echoerr "no output"
  else
    botright 10new
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nomodified
    setlocal nornu nonu
    setlocal nospell colorcolumn=0
    silent put=message
  endif
endfunction
command! -nargs=+ -complete=command -bar Redir call Scratchify(<q-args>)

" }}}

" Autocmd {{{
" Put all autocmds into this group so this file is
" safe to be re-sourced, by clearing all first with autocmd!
augroup vimrc
  autocmd!
augroup END

autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal complete+=k
autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal tw=78 spell
autocmd vimrc BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
autocmd vimrc BufWritePost ~/.vim/vimrc source ~/.vim/vimrc
autocmd vimrc BufWritePre /tmp/* setlocal noundofile

" Quickfix/Location List
autocmd vimrc FileType * if &ft ==# 'qf' | setlocal nonu nornu | endif
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost  l* lwindow
autocmd vimrc VimEnter * cwindow

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

" }}}

" Playground {{{

function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
nnoremap gm :call <SID>SynStack()<CR>

" }}}
