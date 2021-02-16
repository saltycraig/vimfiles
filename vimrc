" vim: fdm=indent nowrap ft=vim
scriptencoding utf-8
 
runtime defaults.vim
runtime macros/matchit.vim

let mapleader=' '
let maplocalleader='\'

packadd minpac 

if !exists('g:loaded_minpac')
  echo "minpac not installed."
  finish
endif

command! PackUpdate source $MYVIMRC | call minpac#update()
command! PackClean  source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | call minpac#status()

call minpac#init()
call minpac#add('k-takata/minpac', {'type': 'opt'})
call minpac#add('tpope/vim-commentary') 
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-surround')
" Maybe not this one, 1800 SLOC, don't use most of it
call minpac#add('wellle/targets.vim')
call minpac#add('romainl/apprentice')
call minpac#add('cormacrelf/vim-colors-github')

" https://github.com/tpope/vim-abolish
" https://github.com/tpope/vim-characterize
" https://github.com/tpope/vim-eunuch
" https://github.com/tpope/vim-ragtag
" https://github.com/tpope/vim-sleuth
" https://github.com/tpope/vim-tbone
" https://github.com/tpope/vim-projectionist
" https://github.com/nelstrom/vim-visual-star-search
" https://github.com/godlygeek/tabular
" https://github.com/tommcdo/vim-exchange
" https://github.com/szw/vim-g
" https://github.com/kana/vim-smartinput
" https://github.com/b4winckler/vim-angry
" https://github.com/tweekmonster/helpful.vim
" https://github.com/nelstrom/vim-docopen

set autoindent
set autoread
set belloff=all
set hidden
set hlsearch
set ignorecase 
set laststatus=2
set listchars=eol:$,space:·,
set modeline
set noswapfile
set number
set path-=/usr/include
set path+=**10
set relativenumber
set smartcase
set tags=./tags;,tags;
set termguicolors
set wildcharm=<C-z>
set wildignore+=*.exe
set wildignore+=.git
 
" TODO: play with this and see what is most intuitive
" set wildmode=list:longest,list:full
" set wildmode=full " default
set wildmode=list:full

" Popular NERDTree styling look using builtin netrw
let g:netrw_banner=0
let g:netrw_liststyle=3
let g:netrw_sizestyle='h'
let g:netrw_winsize=15
let g:netrw_list_hide=netrw_gitignore#Hide() . '.*\.swp$'

if has('gui') || has('xterm_clipboard')
  set clipboard=unnamed,unnamedplus
endif

   
" Completions
if has('textprop')
  set completeopt=menuone,popup
else
  set completeopt=menuone,preview
  " TODO: add autocmd to do pclose on autocmd of insertion complete
endif
" <C-p> only completes from current buffer, use <C-n> for wider reach.
inoremap <C-p> <C-x><C-p>
" Enable use of <C-Space> for manual autocomplete request.
inoremap <C-@> <C-x><C-o>

" Re-select visually selected area after indenting/dedenting.
xmap < <gv
xmap > >gv
" Move visual selection up/down lines.
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
" '%%' in command-line mode maybe expands to path of current buffer.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" TODO: fix path naming for these
nnoremap <F3> :call utils#ToggleQuickfixList()<CR>
nnoremap <F4> :call utils#ToggleLocationList()<CR>
nnoremap <F5> :silent! make % <bar> copen <bar> silent redraw!<CR>
nnoremap <F6> :15Lexplore<CR>
nnoremap <F9> :set list!<CR>
nnoremap <F10> :set spell!<CR>

nnoremap <Leader>w :update<CR>
nnoremap <Leader>q :bdelete<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>t :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
nnoremap <Leader>l :buffer #<CR>

" These require 'wildcharm' is set to <C-z>
nnoremap <Leader>ee :edit <C-z><S-Tab>
nnoremap <Leader>es :split <C-z><C-d>
nnoremap <Leader>ev :vsplit <C-z><C-d>
nnoremap <Leader>f :find **/*
nnoremap <Leader>b :buffer <C-z><S-Tab>

" General fuzzy-ish finder using shell globbing.
nnoremap <C-p> :find **/*

" Terminal
tnoremap <Esc> <C-\><C-n> 
tnoremap <C-v><Esc> <Esc>

" 'in-document' text object
xnoremap <silent> id :<C-u>normal! G$Vgg0<CR>
onoremap <silent> id :<C-u>normal! GVgg<CR>

" 'in-indentation' text obect
function! s:inIndentation()
  " Select text of current indentation level. 
  " that precede or follow the current indentationt level;
  "
  " the current implementation is pretty fast, even for many lines since it
  " uses "search()" with "\%v" to find the unindented levels
  "
  " NOTE: if the current level of indentation is 1 (ie in virtual column 1),
  "       then the entire buffer will be selected
  "
  let l:magic = &magic
  set magic
  " move to beginning of line and get virtcol (current indentation level)
  " BRAM: there is no searchpairvirtpos() ;)
  normal! ^
  let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')
  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'
  " find first match (backwards & don't wrap or move cursor)
  let l:start = search(l:pat, 'bWn') + 1
  " next, find first match (forwards & don't wrap or move cursor)
  let l:end = search(l:pat, 'Wn')
  if (l:end !=# 0)
    " if search succeeded, it went too far, so subtract 1
    let l:end -= 1
  endif
  " go to start (this includes empty lines) and--importantly--column 0
  execute 'normal! '.l:start.'G0'
  " skip empty lines (unless already on one .. need to be in column 0)
  call search('^[^\n\r]', 'Wc')
  " go to end (this includes empty lines)
  execute 'normal! Vo'.l:end.'G'
  " skip backwards to last selected non-empty line
  call search('^[^\n\r]', 'bWc')
  normal! $o
  let &magic = l:magic
endfunction

" 'around-indentation' text object
function! s:aroundIndentation()
  " select all text in the current indentation level including any emtpy
  " lines that precede or follow the current indentation level;
  "
  " the current implementation is pretty fast, even for many lines since it
  " uses "search()" with "\%v" to find the unindented levels
  "
  " NOTE: if the current level of indentation is 1 (ie in virtual column 1),
  "       then the entire buffer will be selected
  let l:magic = &magic
  set magic
  " move to beginning of line and get virtcol (current indentation level)
  normal! ^
  let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')
  " pattern matching anything except empty lines and lines with recorded
  " indentation level
  let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'
  " find first match (backwards & don't wrap or move cursor)
  let l:start = search(l:pat, 'bWn') + 1
  " NOTE: if l:start is 0, then search() failed; otherwise search() succeeded
  "       and l:start does not equal line('.')
  " FORMER: l:start is 0; so, if we add 1 to l:start, then it will match
  "         everything from beginning of the buffer (if you don't like
  "         this, then you can modify the code) since this will be the
  "         equivalent of "norm! 1G" below
  " LATTER: l:start is not 0 but is also not equal to line('.'); therefore,
  "         we want to add one to l:start since it will always match one
  "         line too high if search() succeeds
  " next, find first match (forwards & don't wrap or move cursor)
  let l:end = search(l:pat, 'Wn')
  " NOTE: if l:end is 0, then search() failed; otherwise, if l:end is not
  "       equal to line('.'), then the search succeeded.
  " FORMER: l:end is 0; we want this to match until the end-of-buffer if it
  "         fails to find a match for same reason as mentioned above;
  "         again, modify code if you do not like this); therefore, keep
  "         0--see "NOTE:" below inside the if block comment
  " LATTER: l:end is not 0, so the search() must have succeeded, which means
  "         that l:end will match a different line than line('.')
  if (l:end !=# 0)
    " if l:end is 0, then the search() failed; if we subtract 1, then it
    " will effectively do "norm! -1G" which is definitely not what is
    " desired for probably every circumstance; therefore, only subtract one
    " if the search() succeeded since this means that it will match at least
    " one line too far down
    " NOTE: exec "norm! 0G" still goes to end-of-buffer just like "norm! G",
    "       so it's ok if l:end is kept as 0. As mentioned above, this means
    "       that it will match until end of buffer, but that is what I want
    "       anyway (change code if you don't want)
    let l:end -= 1
  endif
  " finally, select from l:start to l:end
  execute 'normal! '.l:start.'G0V'.l:end.'G$o'
  " restore magic
  let &magic = l:magic
endfunction

xnoremap <silent> ai :<c-u>call <sid>aroundIndentation()<cr>
onoremap <silent> ai :<c-u>call <sid>aroundIndentation()<cr>

" 'in indentation' (indentation level sans any surrounding empty lines)
xnoremap <silent> ii :<c-u>call <sid>inIndentation()<cr>
onoremap <silent> ii :<c-u>call <sid>inIndentation()<cr>

function! CCR()
  " make list-like commands more intuitive
  " https://gist.github.com/romainl/047aca21e338df7ccf771f96858edb86
    let cmdline = getcmdline()
    if cmdline =~ '\v\C^(ls|files|buffers)'
        " like :ls but prompts for a buffer command
        return "\<CR>:b"
    elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
        " like :g//# but prompts for a command
        return "\<CR>:"
    elseif cmdline =~ '\v\C^(dli|il)'
        " like :dlist or :ilist but prompts for a count for :djump or :ijump
        return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
    elseif cmdline =~ '\v\C^(cli|lli)'
        " like :clist or :llist but prompts for an error/location number
        return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
    elseif cmdline =~ '\C^old'
        " like :oldfiles but prompts for an old file to edit
        set nomore
        return "\<CR>:sil se more|e #<"
    elseif cmdline =~ '\C^changes'
        " like :changes but prompts for a change to jump to
        set nomore
        return "\<CR>:sil se more|norm! g;\<S-Left>"
    elseif cmdline =~ '\C^ju'
        " like :jumps but prompts for a position to jump to
        set nomore
        return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
    elseif cmdline =~ '\C^marks'
        " like :marks but prompts for a mark to jump to
        return "\<CR>:norm! `"
    elseif cmdline =~ '\C^undol'
        " like :undolist but prompts for a change to undo
        return "\<CR>:u "
    else
        return "\<CR>"
    endif
endfunction
" run above function when Enter hit on command line
cnoremap <expr> <CR> CCR()

if has('mac') && has('gui_running')
  " macvim GUI
  set macmeta
  nnoremap ê <C-w>p<C-e><C-w>p
  nnoremap ë <C-w>p<C-y><C-w>p
  nnoremap Ê <C-w>p<C-d><C-w>p
  nnoremap Ë <C-w>p<C-u><C-w>p
elseif has('mac')
  " Alacritty
  nnoremap ∆ <C-w>p<C-e><C-w>p
  nnoremap ˚ <C-w>p<C-y><C-w>p
  nnoremap Ô <C-w>p<C-d><C-w>p
  " TODO: Alacritty doesn't recognize Shift-Alt-k for some reason
  " nnoremap <C-w>p<C-u><C-w>p
endif

augroup vimrc
  autocmd!
augroup END

" Textfiles, vimrc files
autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal complete+=k
autocmd vimrc BufNewFile,BufRead *.txt,*.md,*.adoc setlocal tw=78
autocmd vimrc BufWinEnter */doc/*.txt setlocal nonumber norelativenumber
autocmd vimrc BufWritePost ~/.vim/vimrc source ~/.vim/vimrc

" Quickfix/Location List
autocmd vimrc FileType * if &ft ==# 'qf' | setlocal nonu nornu | endif
autocmd vimrc QuickFixCmdPost [^l]* cwindow
autocmd vimrc QuickFixCmdPost  l* lwindow
autocmd vimrc VimEnter * cwindow
if (v:version >=# 802)
  packadd! cfilter
endif

" Getting Help Easier
nnoremap <F1>f :help list-functions<CR>
nnoremap <F1>k :help keycodes<CR>
command! Api :help list-functions<CR>

command! Cd :cd %:h
command! TodoLocal :botright lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Only :.+,$bwipeout<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>

" GUI v. TUI settings
if !has('gui') && !has('gui_running')
  " Use Esc (^[) for terminal emulators for Alt support
  " macvim, gvim, etc. won't need this because they support Alt keys
  nnoremap j <C-w>p<C-e><C-w>p
  nnoremap k <C-w>p<C-y><C-w>p
  nnoremap J <C-w>p<C-d><C-w>p
  nnoremap K <C-w>p<C-u><C-w>p
elseif has('gui') && has('gui_running')
  " Put variants that work on GUI here
  echom 'Set up GUI Alt-key bindings here.'
endif

set background=light
colorscheme github

" IDEAS:
" * 'q' to quit any help buffer, tab key cycles through links there.
" * comes with actual help file, telling you how to find The Way.
" * incorporate vimways.org articles where possible
" * Weird idea: remap any key pressed in command line to do key and
" then tab key try autocompletion or show multiple results if not
" unique enough yet, then you press another key and it narrows more.

