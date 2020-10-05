" Info: ftplugin for .vim files
" Author: C.D. MacEachern <craigm@fastmail.com>
" Last Modified: 2020-04-17
" Notes: Using google style guide:
" * use two spaces for indents -> :set tabstop=2 shiftwidth=2
" * do not use tabs -> :set expandtab
" * use spaces around operators
" * restrict to 80 chars wide
" * indent cont'd lines by four spaces
" * plugin-names-like-this
" * FunctionNamesLikeThis
" * CommandNamesLikeThis
" * augroup_names_like_this
" * variable_names_like_this
" * always prefix vars with scope, e.g. g:/s:/w:/b:
" * when in doubt, use python style guide rules
setlocal autoindent
setlocal expandtab
setlocal shiftwidth=2
setlocal tabstop=2
setlocal textwidth=80
setlocal foldmethod=marker
let &l:define = '\C^command\|function'

" HACK: attempt to fix 'foo.vim' and 'vim-package' highlighting
" '.vim' is highlighted and 'vim-' is highlighted by making
" them part of keyword it changes highlighting group and we can
" navigate over them easier too with word motions like w and e.
setlocal iskeyword+=.
setlocal iskeyword+=-
