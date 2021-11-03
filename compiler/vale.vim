" Vale CLI runner
" Compiler: vale

if exists('current_compiler')
  finish
endif
let current_compiler = 'vale'

let s:cpo_save = &cpo
set cpo&vim

" Check if it's an actual command and if not create one (compatibility-thing)
" with older Vim which used :setlocal only
if exists(":CompilerSet") != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=vale
CompilerSet errorformat=%f:\ line\ %l:\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
