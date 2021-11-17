# Vim setup

## Runtime path explained

https://learnvimscriptthehardway.stevelosh.com/chapters/42.html

## Replicating the whole setup on new machine

```sh
git clone --recursive git@github.com:craigmac/vimfiles ~/.vim
```

## Update single package

```sh
cd ~/.vim/pack/third-part/start/vim-foo
git pull origin master
```

## Removing package

```sh
cd ~/.vim
git submodule deinit pack/third-party/start/vim-foo
git rm -rf pack/third-party/start/vim-foo
rm -r .git/modules/pack/start/vim-foo
```
