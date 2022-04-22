setlocal shiftwidth=2
setlocal softtabstop=2
setlocal expandtab
setlocal foldmethod=indent

let b:undo_ftplugin .= '|setlocal shiftwidth< softtabstop< et< fdm< cursorcolumn<'
