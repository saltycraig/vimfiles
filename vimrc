" vim: fdm=marker nowrap ft=vim et sts=2 ts=2 sw=2 fdl=99

" Bare-basics {{{
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
set encoding=utf-8
scriptencoding utf-8
let mapleader=' '
" }}}

" Plugin Settings {{{

" defaults I never use
let g:loaded_getscriptPlugin = 1
let g:loaded_logiPat = 1
let g:loaded_vimballPlugin = 1
let g:loaded_vimball = 1

" $VIMRUNTIME/pack/dist/opt/<plugin>
packadd! matchit " extended 'matchpairs', basically
packadd! cfilter

" pack/third-party/opt/<plugin>
packadd! apprentice
packadd! fzf.vim
packadd! vim-commentary
packadd! vim-gitbranch
packadd! vim-liquid
packadd! vim-repeat
packadd! vim-surround
packadd! vim-textobj-user
packadd! vim-textobj-entire
packadd! vim-textobj-indent

" brew install fzf first
if executable('fzf') && has('mac')
    set runtimepath+=/usr/local/opt/fzf
endif

" fzf.vim
nnoremap <C-p> :GFiles<CR>
" FZF from directory buffer is in, use this when not in Git repo
nnoremap <Leader>e. :FZF %:h<CR>
" Jump to buffer in existing window if possible with this option
let g:fzf_buffers_jump = 1
nnoremap <Leader><Tab> :Buffers<CR>

" Change to git project directory
nnoremap <Leader>c :FZFCd ~/git<CR>
nnoremap <Leader>C :FZFCd!<CR>
nnoremap <Leader><C-]> :Tags<CR>
command! -bang -bar -nargs=? -complete=dir FZFCd
  \ call fzf#run(fzf#wrap(
  \ {'source': 'find '.( empty("<args>") ? ( <bang>0 ? "~" : "." ) : "<args>" ) .' -type d',
  \ 'sink': 'cd'}))
" Function used to populate Quickfix with selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }
" Layout of fzf UI
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" Default toggle preview window key of <C-/> is not widely supported on
" terminal emulators. Also it slows things down. Off until toggled on.
let g:fzf_preview_window = ['right:60%:hidden', 'ctrl-o']
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['bg', 'Error'],
  \ 'fg+':     ['fg', 'Pmenu'],
  \ 'bg+':     ['bg', 'Pmenu'],
  \ 'hl+':     ['bg', 'Error'],
  \ 'info':    ['fg', 'Normal'],
  \ 'border':  ['fg', 'Normal'],
  \ 'prompt':  ['fg', 'Statement'],
  \ 'pointer': ['fg', 'Statement'],
  \ 'marker':  ['fg', 'Statement'],
  \ 'gutter':  ['bg', 'Normal'],
  \ 'spinner': ['fg', 'Label'],
  \ 'preview-fg': ['fg', 'Normal'],
  \ 'preview-bg': ['bg', 'Normal'],
  \ 'header':  ['fg', 'Comment'] }
" }}}

" Options {{{
" Indenting/Formatting
" copy above line indent on enter
set autoindent
" indent after {, after a line with a keyword from 'cinwords',
" before a line starting with }. } as first char is given same
" indent as matching {. When 'cindent' is on or 'indentexpr' is set
" smartindent has no effect. 'indentexpr' is the most advanced version.
" 'cindent' is mainly for C stuff specifically.
set smartindent
set autoread " auto re-read files changes outside of Vim
set belloff=all | " no sounds for all possible bell events
" yank/delete/change/put ops go to clipboard registers * and +
" Normally they would go to unnamed register.
" This isn't supposed to work without :echo has('X11') and
" :echo has('xterm_clipboard') but in my tests on macos both are 0 but work!
set clipboard=unnamed,unnamedplus
set complete+=d | " C-n/p scans include i_CTRL-X_CTRL-D results too
" completion menu can show even when only one match, and instead of preview
" window if there's extra information, use the 'popupwin' feature
set completeopt=menuone,popup
try " 8.1 something this became an option
  set diffopt+=algorithm:patience | " http://vimways.org/2018/the-power-of-diff/
catch /E474/
  set diffopt=vertical,iwhiteall,filler
endtry
set exrc | " Enable .vimrc/.exrc/.gvimrc auto read from pwd, for projects
set foldlevelstart=99 | " No folds closed by default. Modeline 'fdls' overrules 
set hidden " hide buffers without needing to save them
set history=10000 | " Max possible value, use <C-f> in commandline to browse
set hlsearch " highlight all search matches until :nohl run
set laststatus=2 | " always show statuslines in all windows
set listchars=tab:\|\ ,space:·,trail:· | " strings to show when :set list is on
set mouse=a
set noswapfile " no annoying *.foo~ files left around
set nowrap " defaults to line wrapping on
set number relativenumber " current line number shown - rest shown relative
set path-=/usr/include |  set path+=** | " Look recursively from ':pwd'
set secure " autocmd, shell, and write commands not allow in dir exrc
set shell=$SHELL | " macvim supposed to use this, but doesn't and sets 'sh'
set showmatch " on brackets briefly jump to matching to show it
set statusline=\ %f | " buffer name relative to :pwd
set statusline+=%m%r%h | " [+] when modified, [-] no modify [RO] and [help]
set statusline+=%= | " Start right-hand side of statusline
" Requires https://github.com/itchyny/vim-gitbranch function
set statusline+=%{gitbranch#name()} | " master
set statusline+=\ [%Y]
set statusline+=\ %P
set statusline +=\ %l:%c\ 
set suffixes+=.png,.jpeg,.jpg,.exe | " 
set shortmess-=cS | "  No '1 of x' pmenu messages. [1/15] search results shown.
" Use for non-gui tabline, for gui use :h 'guitablabel'
set tabline=%!vim9utils#mytabline()
set ignorecase smartcase " ignore case in searches, UNLESS capitals used
set showtabline=2 | " Always show tabline
set signcolumn=number
set splitbelow " new horizontal split window always goes below current
set splitright " same but with new vertical split window
set tags=./tags;,tags; | " pwd and search up til root dir for tags file
set thesaurus=~/.vim/thesaurus/english.txt | " Use for :h i_CTRL-X_CTRL-T
set undofile undodir=~/.vim/undodir | " persistent undo on and where to save
" Character to act as 'wildchar' in a macro because <Tab> is unrecognized there
" Use in mapping to do auto-expansion like this:
" set wcm=<C-Z> | cnnoremap ss so $VIM/sessions/*.vim<C-Z>
set wildcharm=<C-z>
set wildignore=*.o,*.obj
set wildignore+=*.exe,*.dylib,%*
set wildignore+=*.png,*.jpeg,*.bmp,*.jpg
set wildignore+=*.pyc
set wildoptions=tagfile | " :tag <C-d> will show tag kind and file

if has('termguicolors')
  " Terminal.app only supports 256 still (in 2021...)
  if !$TERM_PROGRAM =~# 'Apple_Terminal'
    set termguicolors
  endif
endif

if executable('git')
  set grepprg=git\ grep\ -Hnri\ 
else
  set grepprg=grep\ -Hnri
endif

" TODO: maybe off? investigate
" enable use of folding with ft-markdown-plugin
let g:markdown_folding = 1

" enable :Man command and use it's folding
runtime! ftplugin/man.vim
let g:ft_man_folding_enable=1

" }}}

" Mappings {{{

if has('gui_macvim') && has('gui_running')
  " macvim installation 'vim' binary requires check if gui_running as well
  set guitablabel=%!vim9utils#myguitablabel()
  let g:macvim_skip_cmd_opt_movement = 1
endif

" manual expansions, when I want it
inoremap (<CR> (<CR>)<Esc>O
inoremap (; (<CR>);<Esc>O
inoremap (, (<CR>),<Esc>O
inoremap {; {<CR>};<Esc>O
inoremap {, {<CR>},<Esc>O
inoremap [<CR> [<CR>]<Esc>O
inoremap [; [<CR>];<Esc>O
inoremap [, [<CR>],<Esc>O

" e.g. typing ':help g<C-p>' by default does not search history and simply
" goes to previous entry, but ':help g<Up>' will search history for previous
" pattern matching ':help g'. Also Up/Down go in/out of subfolders listings
" when wildmenu showing - default C-n/p here is to traverse results, equivalent
" to <Tab>/<S-Tab>. 
cnoremap <expr> <C-p> wildmenumode() ? "<C-P>" : "<Up>"
cnoremap <expr> <C-n> wildmenumode() ? "<C-N>" : "<Down>"

" If completion menu open use C-j/k instead of arrow keys to navigate
" parent/child folders.
cnoremap <expr> <C-j> wildmenumode() ? "\<Down>\<C-z>" : "\<C-j>"
cnoremap <expr> <C-k> wildmenumode() ? "\<Up>\<C-z>" : "\<C-k>"

" keeps marks, settings, and you can still do e.g., <C-o> to jump to it
nnoremap <Leader>dd <Cmd>bdelete!<CR> 
" REALLY delete the buffer.
nnoremap <Leader>D <Cmd>bwipeout!<CR>

" :find (&path aware) and :edit niceties
nnoremap <Leader>ff :find *
nnoremap <Leader>fs :sfind *
nnoremap <Leader>fv :vert sfind *
" Tab-expand to show wildmenu then untab to unselect but still see menu
nnoremap <Leader>ee :edit *<C-z><S-Tab>
nnoremap <Leader>es :split *<C-z><S-Tab>
nnoremap <Leader>ev :vert split *<C-z><S-Tab>

" :buffer for showing listed buffers, :buffers! for everything
nnoremap <Leader>bb :buffer <C-d>
nnoremap <Leader>bs :sbuffer <C-d>
nnoremap <Leader>bv :vert sbuffer <C-d>

" NOTE: these need nmap to fire the CCR() function to determine how
" to handle the <CR> key at the end.
" tags
nmap <Leader>tj :tjump /<CR>
" preview window, close with C-w z
nmap <Leader>tp :ptjump /<CR>

" jumping: dlist here is remapping to djump in CCR()
nmap <Leader>dl :dlist /<CR>
" instead of just showing where the definition is setup to do the jump
nnoremap [D [D:djump<Space><Space><Space><C-r><C-w><S-Left><Left>
nnoremap ]D ]D:djump<Space><Space><Space><C-r><C-w><S-Left><Left>
nnoremap <Leader>i :ilist /
" Fill it out ready to do the jump
nnoremap [I [I:djump<Space><Space><Space><C-r><C-w><S-Left><Left>
nnoremap ]I ]I:djump<Space><Space><Space><C-r><C-w><S-Left><Left>

" Tmux functionality that I used
nnoremap <silent><C-b>v :vertical terminal ++close zsh<CR> 
nnoremap <silent><C-b>s :terminal ++close zsh<CR> 
tnoremap <silent><C-b>v <C-\><C-n>:vertical terminal ++close zsh<CR> 
tnoremap <silent><C-b>s <C-\><C-n>:terminal ++close zsh<CR> 
tnoremap <silent><C-b>g <C-\><C-n>:terminal ++close lazygit<CR>
nnoremap <silent><C-b>! <C-w>T

" resizing windows
nnoremap <silent><S-Up> <Cmd>2wincmd+<CR>
nnoremap <silent><S-Down> <Cmd>2wincmd-<CR>
nnoremap <silent><S-Left> <Cmd>2wincmd <<CR>
nnoremap <silent><S-Right> <Cmd>2wincmd ><CR>

" one off terminal buffer
nnoremap <silent><C-b>g :terminal ++close lazygit<CR>
nnoremap <silent><C-b><CR> :terminal make<CR>

" Re-select visually selected area after indenting/dedenting.
xmap < <gv
xmap > >gv

" Move visual selection up/down lines.
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv

nnoremap <silent> [l :silent! lprevious<CR>
nnoremap <silent> ]l :silent! lnext<CR>
"
" '%%' in command-line mode maybe expands to path of current buffer.
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Function keys
nnoremap <silent><F3> :call vim9utils#ToggleQuickfixList()<CR>
nnoremap <silent><F4> :call vim9utils#ToggleLocationList()<CR>
nnoremap <silent><F7> :15Lexplore<CR>
nnoremap <silent><F9> :set list!<CR>
nnoremap <silent><F10> :set spell!<CR>
nnoremap <silent><Leader>* :grep <cword><CR>

" iTerm2/Terminal.app: gvimrc sets these for macvim
nnoremap j <C-w>p<C-e><C-w>p
nnoremap k <C-w>p<C-y><C-w>p
nnoremap J <C-w>p<C-d><C-w>p
nnoremap K <C-w>p<C-u><C-w>p

" Leader keys
nnoremap <Leader>w :update<CR>
nnoremap <Leader>, :edit $MYVIMRC<CR>
nnoremap <Leader>ft :e <C-R>=expand('~/.vim/after/ftplugin/'.&ft.'.vim')<CR><CR>
nnoremap <Leader><Leader> :buffer #<CR>
nnoremap <Leader><CR> :source %<CR>

" Vimdiff
nnoremap gh :diffget //2<CR>
nnoremap gl :diffget //3<CR>

" vim-unimpaired style
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprev<CR>
nnoremap ]T :tablast<CR>
nnoremap [t :tabfirst<CR>

" }}}

" Commands {{{

function! Grep(...) abort " accepts any number of args
  " Based on: https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
  " expandcmd allows us to do :Grep 'leader' % and have % expanded to current
  " file like default :grep cmd does
  return system(join([&grepprg] + [expandcmd(join(a:000))]))
endfunction
command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
" replace standard :grep with ours automatically
cnoreabbrev <expr> grep (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

command! Api :help list-functions<CR>
command! Cd :lcd %:h
command! TodoLocal :botright silent! lvimgrep /\v\CTODO|FIXME|HACK|DEV/ %<CR>
command! Todo :botright silent! vimgrep /\v\CTODO|FIXME|HACK|DEV/ *<CR>

" https://github.com/romainl/minivimrc
" Sugar to make common non-interactive commands like :jumps friendlier by
" setting you up to then jump. Otherwise nothing added.
cnoremap <expr> <CR> <SID>CCR()
function! s:CCR()
  command! -bar Z silent set more|delcommand Z
  if getcmdtype() ==# ':'
    let cmdline = getcmdline()
    " TODO: maybe wrap these in a try to catch cancelled jump and send <CR>
    " to avoid the dreaded hit enter prompt
    " :dlist|ilist becomes :djump/ijump instead
    if cmdline =~# '\v\C^(dli|il)' | return "\<CR>:" . cmdline[0] . "jump   " . split(cmdline, " ")[1] . "\<S-Left>\<Left>\<Left>"
    elseif cmdline =~# '\v\C^(cli|lli)' | return "\<CR>:silent " . repeat(cmdline[0], 2) . "\<Space>"
    elseif cmdline =~# '\C^changes' | set nomore | return "\<CR>:Z|norm! g;\<S-Left>"
    elseif cmdline =~# '\C^ju' | set nomore | return "\<CR>:Z|norm! \<C-o>\<S-Left>"
    elseif cmdline =~# '\v\C(#|nu|num|numb|numbe|number)$' | return "\<CR>:"
    elseif cmdline =~# '\C^ol' | set nomore | return "\<CR>:Z|e #<"
    elseif cmdline =~# '\v\C^(ls|files|buffers)' | return "\<CR>:b"
    elseif cmdline =~# '\C^marks' | return "\<CR>:norm! `"
    elseif cmdline =~# '\C^undol' | return "\<CR>:u "
    else | return "\<CR>" | endif
  else | return "\<CR>" | endif
endfunction

" Jekyll
command! JekyllOpen call utils#JekyllOpenLive()
nnoremap <Leader>@ :JekyllOpen<CR> 

" TODO:
" Create command to Yank full path of current file to system clipboard, relative
" to the git directory.
" }}}

" Autocmd {{{
" Put all autocmds into this group so this file is
" safe to be re-sourced, by clearing all first with autocmd!
augroup vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC nested source $MYVIMRC
  autocmd BufWritePre /tmp/* setlocal noundofile
  autocmd QuickFixCmdPost [^l]* botright cwindow
  autocmd QuickFixCmdPost  l* botright lwindow
  autocmd VimEnter * cwindow
  autocmd FileType gitcommit call feedkeys('i')
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
  " I also set this in utils#Redir because it does 'nobuflisted'
  " This one catches other things that open 'nofile' buffers
  autocmd BufEnter * if &buftype ==# 'nofile' | nnoremap <buffer> q :bwipeout!<CR> | endif
augroup END

" }}}

" Colorscheme and Syntax {{{

" See all active highlight groups with:
" :so $VIMRUNTIME/syntax/hitest.vim
"
" Colorscheme Extras for Plugins {{{
" colorscheme apprentice " widest support
" colorscheme apprentice
colorscheme apprentice


"}}}

function! SynGroup() " Outputs both the name of the syntax group, AND the translated syntax
  " group of the character the cursor is on.
  " line('.') and col('.') return the current position
  " synID(...) returns a numeric syntax ID
  " synIDtrans(l:s) translates the numeric syntax id l:s by following highlight links
  " synIDattr(l:s, 'name') returns the name corresponding to the numeric syntax ID
  " example output:
  " vimMapModKey -> Special
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction
nnoremap <F2> :call SynGroup()<CR>
"}}}

" Playground {{{

" Terminal cursors:
"https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes
" Cursor settings:
"  1 -> blinking block  2 -> solid block  3 -> blinking underscore  4 -> solid underscore
"  5 -> blinking vertical bar 6 -> solid vertical bar
" Insert mode
let &t_SI = "\e[6 q"
" Normal mode
let &t_EI = "\e[2 q"

" Grepping
nmap <Leader>/ :grep<Space>
nnoremap <Leader>? :vimgrep //j **/*.md<S-Left><S-Left><Right>

command! -nargs=1 Redir call utils#Redir(<q-args>)
nnoremap <Leader>! :Redir<Space>

nnoremap g; g;zv
nnoremap g, g,zv
nnoremap <silent> } :keepjumps normal! }<CR>
nnoremap <silent> { :keepjumps normal! {<CR>

" }}}

" Neovim backports {{{
" Don't restore global maps/options, let vimrc handle that
set viewoptions-=options
set sessionoptions-=options
" Neovim really maps Q to execute last recorded macro which could be any
" register, but I mostly just use qq so no need to create elaborate backport
nnoremap Q @q
nnoremap Y y$
nnoremap <C-L> <Cmd>nohlsearch<Bar>diffupdate<CR><C-L>
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" }}}

" Experimental {{{

" Command to load files changed in commit(?) from SO here:
" https://vi.stackexchange.com/questions/13433/how-to-load-list-of-files-in-commit-into-quickfix
" command -nargs=? -bar Gshow call setqflist(map(systemlist("git show --pretty='' --name-only <args>"), '{"filename": v:val, "lnum": 1}'))

" }}}
