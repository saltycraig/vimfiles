setlocal complete+=k
setlocal foldlevel=99
setlocal suffixesadd=.md
setlocal list
setlocal expandtab
setlocal shiftwidth=3
setlocal softtabstop=3
setlocal tabstop=3

" Better when 'set wrap' on
nnoremap <buffer> j gj
nnoremap <buffer> k gk

" Taken from upstream tpope/vim-markdown, remove this when $VIMRUNTIME/ftplugin/markdown.vim
" catches up (current version is from 2019).
nnoremap <silent><buffer> [[ :<C-U>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR>
nnoremap <silent><buffer> ]] :<C-U>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR>
xnoremap <silent><buffer> [[ :<C-U>exe "normal! gv"<Bar>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "bsW")<CR>
xnoremap <silent><buffer> ]] :<C-U>exe "normal! gv"<Bar>call search('\%(^#\{1,5\}\s\+\S\\|^\S.*\n^[=-]\+$\)', "sW")<CR>

