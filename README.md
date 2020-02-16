## home-env
This repository configures my "home environment" on all machines (personal and
work). It configures dotfiles (ex .bashrc) as well as manages packages
for editors (ex ctrlp for vim). It also sets up useful shell functions and aliases.

This repository was inspired by and copy and pasted from [biviosoftware
home-env](https://github.com/biviosoftware/home-env).

## OS
I work on macOS, Ubuntu, Fedora, and CentOS. My configuration should work across
all of those systems

### macOS
- To swap left ctrl and alt keys use [karabiner](https://pqrs.org/osx/karabiner/)
(on linux systems I use xmodmap which is one of the configuration files
contained in this repo so you don't have to do anything manual).
- In iTerm2 I swap [right alt with esc+](https://www.iterm2.com/faq.html) (
search for "esc+").

## Firefox
- I prefer to cycle through tabs in order not most recently used. To do so
enter `about:config` in the address bar, type ctrl in the search box, double
click `browser.ctrlTab.previews` so it's value becomes `false`.


## Editor
Emacs is my main editor. I currently use version 26.3. See the install instructions below.


### Other editor options
I also sometimes use vi, vim, neovim, and vscode. There is configuration
contained within for how I like them configured but I don't update it
because I use mostly emacs now. On systems without my emacs config I use vi and
when I just want to look at a random file on my machine and not edit it sometimes
I'll use vscode.

### vscode setup
I have it setup in [portable mode](https://code.visualstudio.com/docs/editor/portable)
so it is easier to manage the configuration of it across systems.

### vscode on linux
- Download the tarball from the vscode downloads page
- Unpack it into a directory named `vscode`
- move that directory into `/opt`

### emacs setup
- Download the desired emacs version found https://ftp.gnu.org/pub/gnu/emacs/. 26.3 seems to work
- `tar -zxvf emacs-VERSION.tar.gz`
- `cd emacs-VERSION`
- `./configure --with-x-toolkit=no --without-x # you may need to install other packages (ex libjpg) if you desire them and your system doesn't have them`
- `make`
- `sudo make install`

## Setup instructions
*DISCLAIMER:* This installation will overwrite your existing dotfiles and any
other files in it's way. It should move most files to a `*.old` but makes no
guarantees about this. If you are uncomfortable with the possibility of ruining
your existing configuration (or worse) I suggest reading through the sources
and copying and pasting the things you need. Another option is to fork and
change what makes sense for you.
1. `mkdir -p ~/src/e-carlin`
2. `cd $_ && git clone --recursive git@git.sr.ht:~e-carlin/home-env`
3. `cd home-env`
4. `bash install.sh # shows you what will happen`
5. `bash install.sh -c # applies changes. -c stands for "confirm"`
