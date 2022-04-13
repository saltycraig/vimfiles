if exists('current_compiler')
  finish
endif
let current_compiler = 'liquid'

" older Vim always used :setlocal
if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=\(\ markdownlint-cli2\ %\ >\ /dev/null\ ;\ vale\ --no-wrap\ --no-exit\ --output='line'\ %\ ;\ \) 

" Only Add otherwise it wipes out all others
CompilerSet errorformat=%f:%l:%c\ %m,%f:%l:%c:%m,%f:%l\ %m
