" vim:set fdm=marker nowrap ft=vim fdl=2 nolist:
" Options {{{1
" Syntax/FileType/Encoding {{{2
filetype plugin indent on
syntax on
set encoding=utf-8
scriptencoding utf-8
let mapleader=' '
" Whitespace/Indenting/Linebreaks {{{2
set autoindent smartindent
set backspace=indent,eol,start
set formatoptions+=j
set linebreak breakindent showbreak=+
set listchars=tab:\|\ ,lead:*,trail:*,eol:$,precedes:<,extends:>
" Visuals {{{2
set belloff=all
set completeopt=menuone,popup
set modeline modelines=5
set nocursorline
" set diffopt+=algorithm:patience
set display=truncate
set foldlevelstart=1
set foldopen+=jump
set hlsearch incsearch
set laststatus=2
set mouse=a
set nolangremap
set number relativenumber
set ruler
set scrolloff=1 sidescrolloff=2
set shortmess-=cS
set showcmd showmatch
set showtabline=1
set signcolumn=number
set tabline=%!vim9utils#MyTabline()
" set statusline=%!vim9utils#MyStatusline()
set statusline=%f\ %M\ %R\ %H\ %=%{FugitiveStatusline()}\ %Y
" Editing {{{2
set clipboard=unnamed,unnamedplus
set omnifunc=syntaxcomplete#Complete
set complete-=i
set exrc secure
set nrformats-=octal
set ttimeout ttimeoutlen=100
set undofile undodir=~/.vim/undodir
set updatetime=250
" Buffers/Windows/Views/Sessions/Tabpages {{{2
set autoread
set hidden
set history=10000
set noswapfile
set sessionoptions-=options
set splitbelow splitright
set viewoptions-=options
" Menus/Regex/Wildcards/Finding {{{2
set errorformat+=%f | " :cexpr system('cat /tmp/list-o-filenames.txt')
set grepprg=grep\ -HnriE\ $*
set ignorecase smartcase
set path-=/usr/include | set path+=**
set suffixes+=.png,.jpeg,.jpg,.exe
set tags=./tags;,tags;
set wildcharm=<C-z> wildmenu 
" set wildoptions=fuzzy,pum,tagfile
set wildignore+=*.exe,*.dylib,%*,*.png,*.jpeg,*.bmp,*.jpg,*.pyc,*.o,*.obj
" https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
let &t_SI="\e[6 q"
let &t_EI="\e[2 q"

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
let g:tagbar_type_liquid = {
	\ 'kinds' : [
		\ 'c:chapter',
		\ 's:section',
		\ 'S:subsection',
		\ 't:subsubsection',
		\ 'T:13subsection',
		\ 'u:14subsection',
		\ '?:unknown',
	\ ],
\ }

" https://github.com/romainl/vim-qf {{{2
let g:qf_mapping_ack_style = 1
let g:qf_auto_quit = 1

" https://github.com/romainl/vim-cool {{{2
let g:CoolTotalMatches = 1

" https://github.com/w0rp/ale {{{2
let g:ale_set_loclist = 1 | " update loclist, bound to C-n/p for me
let g:ale_set_signs = 0 | " no marks in number/sign columns
let g:ale_disable_lsp = 1 | " turn off ale lsp stuff completely
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰']
let g:ale_set_highlights = 1 | " in-text highlights, not including signs
let g:ale_virtualtext_cursor = 0 | " virtual text at EOL showing lint msg
let g:ale_echo_cursor = 0 | " echo closeby warn/errs on cursor line
let g:ale_cursor_detail = 0 | " open preview win when cursor on line with errs
let g:ale_detail_to_floating_preview = 1 | " Use float win for :ALEDetail
let g:ale_hover_to_floating_preview = 1
let g:ale_floating_preview = 1 | " Use float for everything
let g:ale_hover_to_preview = 0 | " Use preview win for hover messages
let g:ale_hover_cursor = 0
" These plug mappings taken into consideration the location of cursor,
" and need to wrapped this way to add on manual call to ALEDetail for popup
if $TERM_PROGRAM =~# '[Apple_Terminal\|tmux\>]'
	nnoremap <silent>n :execute "normal \<Plug>(ale_next)"<CR>:ALEDetail<CR>
	nnoremap <silent>p :execute "normal \<Plug>(ale_previous)"<CR>:ALEDetail<CR>
else
	nnoremap <silent><M-n> :execute "normal \<Plug>(ale_next)"<CR>:ALEDetail<CR>
	nnoremap <silent><M-p> :execute "normal \<Plug>(ale_previous)"<CR>:ALEDetail<CR>
endif

let g:ale_linters_explicit = 1
let g:ale_linters = {
	\ 'markdown': ['vale', 'cspell', 'markdownlintcli2'],
	\ 'vim': ['vint'],
	\ 'liquid': ['vale', 'cspell', 'markdownlintcli2'],
\}
let g:ale_linter_aliases = { 'liquid': 'markdown' }
" let g:ale_fixers = {}

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

cnoremap <expr> <C-p> wildmenumode() ? "<C-P>" : "<Up>"
cnoremap <expr> <C-n> wildmenumode() ? "<C-N>" : "<Down>"
cnoremap <expr> <C-j> wildmenumode() ? "\<Left>\<C-z>" : "\<C-j>"
cnoremap <expr> <C-k> wildmenumode() ? "\<Right>\<C-z>" : "\<C-k>"

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

nnoremap <silent><F2> :call utils#SynGroup()<CR>
nmap <silent><F3> <Plug>(qf_qf_toggle)
nmap <silent><F4> <Plug>(qf_loc_toggle)
nnoremap <silent><F8> :TagbarOpenAutoClose<CR>
nnoremap <silent><F9> :set list!<CR>
nnoremap <silent><Leader>* :grep <cword> *<CR>

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

" usage: :GitQFShowChanged<CR> to load quickfix with files changes in last commit, or
" :GitQFShowChanged [HEAD^|SHA] to load quickfix with files changed in SHA
command! -nargs=? -bar GitQFShowChanged call setqflist(map(systemlist("git show --pretty='' --name-only <args>"), '{"filename": v:val, "lnum": 1}')) | copen
" usage: :GitQFPRFiles {branchname}<CR> files that are different from given
" branchname are loaded into quickfix. Compared branch is the active one.
command! -complete=customlist,Gitbranches -nargs=1 -bar GitQFPRFiles call setqflist(map(systemlist("git diff --name-only $(git merge-base HEAD <args>)"), '{"filename": v:val, "lnum": 1}')) | copen

function! Gitbranches(ArgLead, CmdLine, CursorPos) abort
	return systemlist('git branch')
endfunction

" Colorscheme and Syntax {{{1
colorscheme apprentice
