setlocal list
setlocal foldlevel=99
setlocal expandtab
compiler vale

" set include=^\\s*{%\ include\ }}\\/

" 1. Check if this even works to call this func and set local path each time a
" Liquid filetype is opened
" let b:path = SetPathFromFilePath()
" let &path = b:path

" " Return string with folder path dynamically modified based on version number
" " matching '\d\.\d\d' found in the path to the current liquid buffer
" function! SetPathFromFilePath() abort
"   " TODO: write FINDVERSIONFUNC which will:
"   " * Strip everything after the filename, so "%}\s*"
"   " * Get full path of current buffer filename
"   " * Find substring matching "\d\.\d\d"
"   " * Relace "{{ page.version }}" in substitute() call with that found substring
"   " setlocal includeexpr=substitute(v:fname, "{{ page.version }}", FINDVERSIONFUNC, "")
"   " We want to set &path dynamically based on version number found in full path to
"   " buffer, for example for a buffer with file of:
"   " /Users/cmaceach/git/devx/docs/_ver_6.14/rn/get-started/intro.md 
"   " We want to extract '6.14' from that string and then setlocal path using that
"   " buffer value, for example
"   " setlocal path='~/git/devx/docs/_ver_' . version_var '
"   let version = '6.14'
"   echom 'Setting local path as: ' . '.,,**,' . '~/git/devx/docs/_ver_' . version . '/'
"   return '.,,**,' . '~/git/devx/docs/_ver_' . version . '/'
" endfunction

" function! LiquidInclude(fname)
"   " Seems to grab up to next whitespace separated character, so it ignores
"   " the '%}' and returns e.g., '/snippets/install-android-studio.md" from
"   " {% include {{ page.version }}/snippets/install-android-studio.md %}
"   echom a:fname
"   " Strip the leading literal /
"   let f = substitute(a:fname, "/", "", "")
"   return f
" endfunction

" setlocal includeexpr=LiquidInclude(v:fname)
"
iabbrev <buffer> wmimp {% alert_box important %}<CR>{% endalert_box %}<Esc>O
iabbrev <buffer> wmnote {% alert_box note %}<CR>{% endalert_box %}<Esc>O
iabbrev <buffer> wmwarn {% alert_box warning %}<CR>{% endalert_box %}<Esc>O
