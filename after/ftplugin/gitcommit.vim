setlocal colorcolumn=73
setlocal textwidth=72
" Colour any character over virtual column 50
match ErrorMsg /.\%>50v/
setlocal spell

let b:undo_ftplugin .= '|setlocal colorcolumn< textwidth< spell<'
