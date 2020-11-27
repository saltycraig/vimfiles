" .vim/after/ftplugin/javascript.vim
" Author: C.D. MacEachern <craigm@fastmail.com>
" Summary: Modifications to javascript detected filetypes,
" done after $VIMRUNTIME/ftplugin/javascript.vim

setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2
setlocal expandtab
setlocal foldmethod=indent

" Previous to commit 207f009326c8f878defde0e594d7d9ed9860106e
" on August 30, 2020, the 'compiler standard' was setting efm value incorrectly,
" and calling without 'npx' prefix as well. I like adding --fix at the same
" time as lint, so I'll just use this one here.
setlocal makeprg=npx\ standard\ --fix
" Keep %-G%.%# at the end for a catch all clause that says 'ignore
" all lines that have not been matching by previous expressions'. Helpful
" for ridding quickfix list of compiler output like version, etc.
setlocal errorformat=\ \ %f:%l:%c:\ %m,%-G%.%#

