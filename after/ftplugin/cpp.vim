" after/ftpluin/cpp.vim -- Local options for C++
" overwriting/adjust defaults in $VIMRUNTIME/ftplugin/c.vim
"
" ctags (Universal ctags) tweak for c++ files:
" $ ctags -R --c++-kinds=+p --fields=+iaS --extras=+q --language-force=C++ .
" Run from top of project dir.

let s:cpo_save = &cpo
set cpo-=C

" Include macros in completion
setlocal complete+=d

" OS-dependent makeprg
if has('win32') || has('win64')
  " gvim with mingw via Code::Blocks (make sure it's 'bin' in %PATH%)
  setlocal makeprg=mingw32-make
else
  setlocal makeprg=make
endif

" Compile single file with F6
nnoremap <buffer> <F6> :!g++ --std=c++17 -Wall -Werror -pedantic %<CR>

" Run single file
nnoremap <buffer> <C-F6> :!%:r<CR>

" Set include pattern
setlocal include=^\\s*#\\s*include
setlocal fdm=syntax

" If ft changed will .cpp buffer open
let b:undo_ftplugin = "setl cpt< inc<"

let &cpo = s:cpo_save
unlet s:cpo_save
