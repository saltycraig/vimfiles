Vim reads all .vim files from inside this directory, indiscriminately.

What it is doing internally is basically `:runtime! plugin/**/*.vim`

It will read ./plugin/foo.vim, ./plugin/bar/foo.vim, ./plugin/bar/foo/foo.vim,
and so on.

Only put stuff in here you WANT to always load, otherwise it's best to just
keep *interfaces* here that call into the actual functions in
./autoload/foo.vim when they are called.
