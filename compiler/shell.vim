" Run current .sh file and capture error output
" Compiler: shell

if exists('current_compiler')
  finish
endif
let current_compiler = 'shell'

let s:cpo_save = &cpo
set cpo&vim

" Check if it's an actual command and if not create one (compatibility-thing)
" with older Vim which used :setlocal only
if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=%
CompilerSet errorformat=%f:\ line\ %l:\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
