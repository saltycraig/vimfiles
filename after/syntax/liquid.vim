" HACK:
" Attempt to provide backtick code block highlight ala
" $VIMRUNTIM/syntax/markdown.vim
"
" See GitHub issue 15: https://github.com/tpope/vim-liquid/issues/15
"
" Trying to adopt the approach that $VIMRUNTIME/syntax/rmd.vim does,
" using the value of g:markdown_fenced_languages and doing it themselves.

if exists('g:markdown_fenced_languages')
  if !exists('g:liquid_fenced_languages')
    let g:liquid_fenced_languages = deepcopy(g:markdown_fenced_languages)
    let g:markdown_fenced_languages = []
  endif
else
  let g:liquid_fenced_languages = []
endif

if !empty(g:liquid_fenced_languages)
  for s:lang in g:liquid_fenced_languages
    " When we have an alias we want to split it, e.g. 'bash=sh'
    if s:lang =~# '='
      let s:syntax_file = substitute(s:lang, '.*=', '', '') " => 'sh'
      let s:codeblock_name = substitute(s:lang, '=.*', '', '') " => 'bash'
    else
      let s:syntax_file = s:lang
      let s:codeblock_name  = s:lang
    endif
    unlet! b:current_syntax
    " examples:
    " execute 'syntax include @Liquidbash syntax/sh.vim' when entry is 'bash=sh'
    " execute 'syntax include @Liquidcpp syntax/cpp.vim' when entry is 'cpp'
    execute 'syntax include @Liquid'.s:codeblock_name.' syntax/'.s:syntax_file.'.vim'
    " Define region INSIDE backquotes as match
    execute 'syntax region liquidFenced'.s:codeblock_name.' matchgroup=liquidCodeDelimiter start="^\s*```\s*'.s:codeblock_name.'\>.*$" matchgroup=liquidCodeDelimiter end="^\s*```\ze\s*$" keepend contains=@Liquid'.s:codeblock_name
    unlet! s:lang
  endfor
endif

hi def link liquidCodeDelimiter Delimiter
