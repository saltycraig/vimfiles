setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2
setlocal expandtab

augroup zsh
	autocmd!
	autocmd FileType zsh if bufname() ==# '.zshrc' | setlocal fdm=marker | endif 
augroup END
