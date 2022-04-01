# macOS Vim source builds

Tested on macOS Big Sur 11.6.5

# Preparation

* Install homebrew.
* Install xcode command line tools
* vim configure script needs to find correct location for these on your $PATH,
so add proper PATH values to your ~/.zshrc:


```sh
xcode-select --install
brew install python ruby cmake
echo '$(brew --prefix)/bin:$PATH' >> ~/.zshrd

```

My path when building (which works):

```sh
echo $PATH
/Library/Ruby/Gems/2.6.0/bin:/usr/local/opt/ruby@3.0/bin:/usr/local/opt/node@12/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/Applications/CMake.app/Contents/bin
```

# First build

All interpreters enabled, no GUI.

```sh
mkdir ~/git && cd ~/git
git clone https://github.com/vim/vim
cd vim/src
./configure --with-features=huge \
	--enable-python3interp \
	--enable-cscope \
	--enable-fail-if-missing \
	--with-compiledby=craig@MBP

# errors without sudo here for xxd tool during build, maybe others
sudo make
sudo make install
```

# Subsequent builds

```sh
cd ~/git/vim/src
git pull
sudo make distclean
sudo make
sudo make install
```

# Removal

```sh
cd ~/git/vim/src
make uninstall
```