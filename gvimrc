" GUI specific settings for Vim 8+

" Turn off alt-{key} being used for menus allowing bindings on alt in GUI
" If you want to bind Alt-key for a menu use e.g., :simalt f<CR> for Alt-f
" F10 will still be menu key, unless bound by user.
set winaltkeys=no
set belloff=all
set guifont=BlexMono\ Nerd\ Font\ Mono:h18

" Start full screen on my mac
set lines=59
set columns=239

" Turn off blinking cursor in all modes
set guicursor=a:blinkon0
" 8.1 default = egmrLtT on windows, else aegimrLtT
" In Windows, don't run popup cmd.exe for external commands,
" use :term instead. See :h gui-shell-win32
set guioptions+=!
" Use console dialogs instead of native ones for simple choices
set guioptions+=c
" Use Vim icon in top-left corner
set guioptions+=i
" Toolbar off
set guioptions-=t
set guioptions-=T
" Right side scrollbar off
set guioptions-=r
" Left side scrollbar off
set guioptions-=L
" Bottom scrollbar off
set guioptions-=b
" Don't use native tabline of system, use same as TUI which I've customized
" and matches colorscheme
set guioptions-=e

" Macvim you can drop and drop bunch of files onto app icon
" and it opens each of them in new tabs, so bump this up from 10
set tabpagemax=100

" cd to directory of this file, macvim sets 'cd' to ~ by default
call chdir(fnameescape(expand("~/.vim")))

" set this macvim specific option to toggle fullscreen on macos
if has('gui_macvim')
  " Under macvim gui make sure that .zprofile is linked to .zshrc, otherwise
  " you'll only get /etc/zprofile sourced and just have default macOS paths
  nnoremap <F11> :set fullscreen!<CR>
  nnoremap ∆ <C-w>p<C-e><C-w>p
  nnoremap ˚ <C-w>p<C-y><C-w>p
  nnoremap Ô <C-w>p<C-d><C-w>p
  nnoremap  <C-w>p<C-u><C-w>p
endif
