" Author: C.D. MacEachern <craigm@fastmail.com>
" Description: vim 8.0+ configuration, requires '+packages'.

" Bootstrap {{{
source $VIMRUNTIME/defaults.vim

let mapleader=' '
let maplocalleader='\'

augroup init
  autocmd!
augroup END
" }}}

" Global Options {{{
set autoread
set complete-=i | " Don't search includes.
" TODO: see how this works with :args **/*.jsx etc., will it scan those?
" set complete-=u | " Don't scan unloaded buffers in buffer list.
set completeopt=menuone,noinsert,noselect
set hidden
set foldnestmax=2
set ignorecase smartcase
set laststatus=2
set noswapfile
set nowrap
set number relativenumber
set path=.,,**5
set signcolumn=yes
set spelllang=en_ca
" default is %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=%<%F\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set splitbelow splitright
set thesaurus=~/.vim/thesaurus/english.txt
set undofile
set undodir=~/.vim/undodir
set wildignore+=*.o,*.obj,*.pyc,*.pyd,*.dll
set wildignore+=*.exe,*.bin,*.zip
set wildignore+=*.bmp,*.jpg,*.jpeg,*.svg,*.png

" Plugin variables
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15
" " }}}

" Packages {{{
packadd! vim-solarized8
packadd! targets.vim
packadd! vim-commentary
packadd! vim-dispatch
packadd! vim-editorconfig
packadd! vim-indent-object
packadd! vim-repeat
packadd! vim-surround
packadd! vim-unimpaired
" }}}

" Mappings {{{
set wildcharm=<C-z>

" Edit/Buffer/Find (adds ignorecase flag for quick completions)
nnoremap <Leader>e :edit <C-d>\c*
nnoremap <Leader>E :split <C-d>\c*
nnoremap <Leader>ve :vsplit<CR>:edit <C-d>\c*

nnoremap <Leader>b :buffer <C-d>*
nnoremap <Leader>B :buffers!<CR>:b
nnoremap <Leader>vb :vsplit<CR>:buffer <C-d>*

nnoremap <Leader>f :find <C-d>\c*
nnoremap <Leader>F :split find <C-d>\c*
nnoremap <Leader>vf :vsplit<CR>:find <C-d>\c*

set splitbelow  " horizontal splitting commands open below always.
set splitright  " vertical splitting commands open to right always.

map q: :q
nnoremap <silent><F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <silent><F4> :call utils#ToggleLocationList()<CR>
nnoremap <silent><F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
nnoremap <silent><F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>
nnoremap <silent><Leader>tn :tabnew<CR>
tnoremap <Esc> <C-\><C-n>
" Send actual Escape char to app running in term, e.g., 'top'
tnoremap <C-v><Esc> <Esc>
nnoremap <Leader>w :update<CR>
" Follows global 'hidden' option wrt what to do when hidden.
nnoremap <Leader>h :hide<CR>
" Unload and delete from :ls/:buffers list (unless '!' post-fix used).
" Option values, vars and maps/abbrevs for the buffer are cleared.
nnoremap <Leader>q :bdelete<CR>
nnoremap <silent><Leader>n :nohlsearch<CR>
nnoremap <silent><Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
" }}}

"  Global Abbreviations {{{
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
" %% in command-line auto-expands to current file's directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" }}}

" Auto-commands {{{
autocmd init QuickFixCmdPost [^l]* cwindow
autocmd init QuickFixCmdPost  l* lwindow
autocmd init VimEnter * cwindow
autocmd init BufWritePre /tmp/* setlocal noundofile
autocmd init BufNewFile,BufRead *.txt,*.md,*.adoc setlocal complete+=k
" HACK: fixes reviving unlisted buffer (:buffers!), because FileType
" is not run unless we do quick :e to trigger it. Adding 'doc/' to match
" only vim help documents (**/doc/foo.txt).
autocmd init BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
autocmd init BufWritePost ~/.vim/vimrc source ~/.vim/vimrc

" }}}

" Commands {{{
" TODO: make this a job() to use async
" TODO: moves these to autoload/utils.vim
command! Todo :silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ **<CR>
command! LocalTodo :lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Cd :cd %:h
" Wipe out all buffers for real (not set to hidden) except current one.
command! Only :.+,$bwipeout<CR>
" }}}

" Whitespace/Tab Settings {{{
" Number of spaces <Tab> counts for. Whether 1 tab byte 0x09 will be replaced
" set tabstop=8
" Governs how much to indent (e.g., >> command)
" Whether it uses spaces or tab character is up to a few settings:
"   * if 'noexpandtab': tries to use tab bytes (\x09) alone. It will use
"   spaces as needed if the result of tabstop / shiftwidth is not 0.
"   * if 'expandtab': only use space bytes.
" Unless you want mixed tab and space bytes (THE HORROR.) if you set
" tabstop and shiftwidth to different values that are non equally divisible,
" use 'expandtab'.
" set shiftwidth=8
" Rounds indenting actions to a multiple of 'shiftwidth' if this is on.
" set noshiftround
" Number of spaces that tab byte \x09 counts for when doing edits like
" when pressing <Tab> or <BS>. It uses a mix of space \x020 and tab
" \x09 bytes. Useful to keep tabstop at 8 while being able to add tabs
" and delete like it is set to softtabstop (insert/remove that many
" whitespaces, made up of space and tab characters).
"  * if 'noexpandtab': number of \x020 (space) bytes are minimized by
"  inserting as many \x09 (tab) bytes as possible.
" set softtabstop=0
" Don't use space bytes \x020 to make up tab \x09 bytes, use real tabs.
" Technically small filesizes with tab characters, but with minification
" on most web/code now being popular, this doesn't matter as much.
" set noexpandtab
" Do not copy indent from current line when starting new line: <CR>,o,O
" set noautoindent
" }}}

" Playground {{{
" TODO: how to detect wsl vs. linux terminal
" * MacVim 8.2 sends: <M-BS>
" * iTerm2 sends:     ÿ
" * wsltty ubuntu 20.04 sends: ^]<BS>. Replace any ^[ with <Esc> in maps
" and it will work.
if has('linux')
  nnoremap <Esc>j <C-w>p<C-e><C-w>p
  nnoremap <Esc>k <C-w>p<C-y><C-w>p
elseif has('mac')
  nnoremap ∆ <C-w>p<C-e><C-w>p
  nnoremap ˚ <C-w>p<C-y><C-w>p
  " Dropping a bunch of files onto MacVim opens each in its own tab,
  " and the default is only 10, so bump it up on MacVim.
  set tabpagemax=100
endif

" Needed last {{{
rviminfo!
silent! helptags ALL
" TODO: guard this somehow. Issue: Terminal.app only has
" 256 colours, so I set the Terminal ANSI 16 to exact Solarized
" palette and use this flag (and make sure :set notermguicolors)
" Otherwise we want to turn on :set termguicolors and turn off flag,
" when using e.g., iTerm2 3+, Windows Terminal, WSL 1&2, alacritty etc.
let g:solarized_use16=1
let g:solarized_old_cursor_style=1
let g:solarized_italics=0
let g:solarized_enable_extra_hi_groups=1
set background=light
colorscheme solarized8
" }}}

" Playground {{{
" TODO: install vim-ocs52

" }}}
