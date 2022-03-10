setlocal nonumber
setlocal norelativenumber
setlocal nolist
setlocal nospell

" maps for buffer, using vim-qf
nmap <buffer> <Left> <Plug>(qf_older)
nmap <buffer> <Right> <Plug>(qf_newer)
nmap <buffer> <Up> :1chistory<CR>
nmap <buffer> <Down> :cnewer 99<CR>
nnoremap <buffer> dd :.Reject<CR>
xnoremap <buffer> d :Reject<CR>
