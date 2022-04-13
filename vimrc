" vim:set fdm=marker nowrap ft=vim fdl=2 nolist:
" Options {{{1
filetype plugin indent on
syntax on
set encoding=utf-8
scriptencoding utf-8
let mapleader=' '
colorscheme apprentice

" set statusline=%!vim9utils#MyStatusline()
set autoindent smartindent
set autoread
set backspace=indent,eol,start
set belloff=all
set clipboard=unnamed,unnamedplus
set complete-=i
set completeopt=menuone,popup
set display=truncate
set errorformat+=%f | " :cexpr system('cat /tmp/list-o-filenames.txt')
set exrc secure
set foldlevelstart=1 foldopen+=jump
set formatoptions+=j
set grepprg=grep\ -HnriE\ $*
set hidden
set history=10000
set hlsearch incsearch
set ignorecase smartcase
set laststatus=2
set linebreak breakindent showbreak=+
set listchars=tab:\|\ ,lead:*,trail:*,eol:$,precedes:<,extends:>
set modeline modelines=5
set mouse=a
set nolangremap
set noswapfile
set nrformats-=octal
set number relativenumber
set omnifunc=syntaxcomplete#Complete
set path-=/usr/include | set path+=**20
set ruler
set scrolloff=1 sidescrolloff=2
set sessionoptions-=options
set shortmess-=cS
set showcmd showmatch
set splitbelow splitright
set statusline=%f\ %M\ %R\ %H\ %=%{FugitiveStatusline()}\ %Y
set suffixes+=.png,.jpeg,.jpg,.exe
set tabline=%!vim9utils#MyTabline()
set tags=./tags;,tags;
set ttimeout ttimeoutlen=100
set undofile undodir=~/.vim/undodir
set updatetime=250
set viewoptions-=options
set wildcharm=<C-z> wildmenu 
set wildignore+=*.exe,*.dylib,%*,*.png,*.jpeg,*.bmp,*.jpg,*.pyc,*.o,*.obj
set wildoptions=tagfile
" Plugins {{{1
" builtins {{{2
packadd! matchit

let g:markdown_fenced_languages = ['cpp', 'jsx=javascriptreact', 'js=javascript', 'cmake', 'bash=sh', 'json']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 1000

" https://github.com/tpope/vim-liquid {{{2
let g:liquid_highlight_types = g:markdown_fenced_languages
"
" https://github.com/preservim/tagbar {{{2
" when using Universal ctags uncomment this:
" let g:tagbar_type_liquid = {
" 	\ 'kinds' : [
" 		\ 'c:chapter',
" 		\ 's:section',
" 		\ 'S:subsection',
" 		\ 't:subsubsection',
" 		\ 'T:13subsection',
" 		\ 'u:14subsection',
" 		\ '?:unknown',
" 	\ ],
" \ }
" using Exuberant ctags with markdown in ~/.ctags defined as
" --langdef=markdown
" --langmap=markdown:.md
" --regex-markdown=/^(#+[ \t]+.*)/\1/h,heading,headings/
let g:tagbar_type_liquid = {
	\ 'kinds' : [
		\ 'h:heading',
	\ ],
\ }

" https://github.com/romainl/vim-qf {{{2
let g:qf_mapping_ack_style = 1
let g:qf_auto_quit = 1

" https://github.com/romainl/vim-cool {{{2
let g:CoolTotalMatches = 1

" https://github.com/tpope/vim-fugitive {{{2
nnoremap <Leader>gg <cmd>G<CR>
nnoremap <silent><Leader>ge :Gedit <bar> only<CR>
nnoremap <silent><Leader>gd <cmd>Gvdiffsplit<CR>
nnoremap <Leader>gD :Gvdiffsplit<space>
nnoremap <Leader>g/ :Ggrep! -HnriqE<Space>
nnoremap <Leader>g? :Git! log -p -S %
nnoremap <Leader>g* :Ggrep! -Hnri --quiet <C-r>=expand("<cword>")<CR><CR>
nnoremap <silent><Leader>gP <cmd>G push<CR>
nnoremap <silent><Leader>gp <cmd>G pull<CR>

" Mappings {{{1
nmap <Leader>/ :grep<Space>
nnoremap <Leader>? :noautocmd vimgrep /\v/gj **/*.md<S-Left><S-Left><Right><Right><Right>
nnoremap <Leader>! :Redir<Space>

" TODO: put this in liquid local mapping
nnoremap <Leader>@ :call utils#JekyllOpen()<CR>

if has('patch-8.2.4325')
	set wildoptions+=pum
	cnoremap <expr> <C-p> wildmenumode() ? "<C-P>" : "<Up>"
	cnoremap <expr> <C-n> wildmenumode() ? "<C-N>" : "<Down>"
	cnoremap <expr> <C-j> wildmenumode() ? "\<Left>\<C-z>" : "\<C-j>"
	cnoremap <expr> <C-k> wildmenumode() ? "\<Right>\<C-z>" : "\<C-k>"
else
	cnoremap <expr> <C-j> wildmenumode() ? "\<Down>\<C-z>" : "\<C-j>"
	cnoremap <expr> <C-k> wildmenumode() ? "\<Up>\<C-z>" : "\<C-k>"
endif

nnoremap <Leader>ff :find *
nnoremap <Leader>fs :sfind *
nnoremap <Leader>fv :vert sfind *
nnoremap <Leader>ee :edit *<C-z><S-Tab>
nnoremap <Leader>es :split *<C-z><S-Tab>
nnoremap <Leader>ev :vert split *<C-z><S-Tab>
" buffers not part of :pwd show '/' or '~' at the beginning, so we can remove
nnoremap <Leader><Leader> :buffer #<CR>
nnoremap <Leader>b. :filter! /^\~\\|^\// ls t<CR>:b
" TODO: extra : added here because of CCR(), investigate further.
" Recreate with :buffer #<CR> will switch buffer then put ':' in cmd line
nnoremap <Leader>bb :buffer <C-z><S-Tab>
nnoremap <Leader>bd <Cmd>bwipeout!<CR>
nnoremap <Leader>bs :sbuffer <C-d>
nnoremap <Leader>bv :vert sbuffer <C-d>

nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [e :lprevious<CR>
nnoremap ]e :lnext<CR>
nnoremap ]E :llast<CR>
nnoremap [E :lfirst<CR>
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :first<CR>
nnoremap ]A :last<CR>

xmap < <gv
xmap > >gv
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

nnoremap <F2> :call utils#SynGroup()<CR>
nmap <F3> <Plug>(qf_qf_toggle)
nmap <F4> <Plug>(qf_loc_toggle)
nnoremap <F5> :silent! lmake \| redraw!<CR>
nnoremap <F8> :TagbarOpenAutoClose<CR>
nnoremap <F9> :set list!<CR>
nnoremap <Leader>* :grep <cword> *<CR>

nnoremap <Leader>w <cmd>update<CR>
nnoremap <Leader>, <cmd>edit $MYVIMRC<CR>
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
nnoremap <Leader><CR> :source %<CR> <bar> :nohlsearch<CR>

nnoremap gh :diffget //2<CR>
nnoremap gl :diffget //3<CR>

" Neovim backports
nnoremap Q @q
nnoremap Y y$
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" Commands {{{1
command! Api :help list-functions<CR>
command! Cd :tcd %:h
command! TodoLocal :botright silent! lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>
command! -nargs=1 Redir call utils#Redir(<q-args>)
command! JekyllOpenDevx call utils#JekyllOpenDevx()
command! -bar ArglistToQuickfix call setqflist(map(argv(-1), '{"filename": v:val}')) <Bar> copen

" load quickfix w files changed in last commit, or given SHA, or HEAD^ style
command! -nargs=? -bar GitQfLoadFilesChanged call setqflist(map(systemlist("git show --pretty='' --name-only <args>"), '{"filename": v:val, "lnum": 1}')) | copen

" load quickfix w files different that given branch name 
command! -complete=customlist,Gitbranches -nargs=1 -bar GitQfChangedFilesOnCurrentBranchVersusGivenBranch call setqflist(map(systemlist("git diff --name-only $(git merge-base HEAD <args>)"), '{"filename": v:val, "lnum": 1}')) | copen
function! Gitbranches(ArgLead, CmdLine, CursorPos) abort
	return systemlist('git branch')
endfunction

