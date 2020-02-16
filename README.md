## home-env
This repository configures my "home environment" on all machines (personal and
development). It configures dotfiles (ex .bashrc) as well as manages packages
for editors (ex ctrlp for vim). It also sets up useful shell functions and aliases.

This repository was inspired by and copy and pasted from [biviosoftware
home-env](https://github.com/biviosoftware/home-env).

## Prerequisites
- If you want to use emacs then have emacs installed.
- If you want to use something like vi then install neovim.
- If you want to use vscode then have it installed.
- If you want copy and paste from emacs to go to your system clipboard install
[xclip](https://github.com/astrand/xclip).
- I like to swap left ctrl and alt keys. On linux systems I use xmodmap and on
macos I use [karabiner](https://pqrs.org/osx/karabiner/).
- If using iTerm swap [right alt with esc+](https://www.iterm2.com/faq.html) (
search for "esc+").

## vscode setup
VSCode is my main text editor. I have it setup in [portable mode](https://code.visualstudio.com/docs/editor/portable)
so it is easier to manage the configuration of it across systems.
### vscode on linux
- Download the tarball from the vscode downloads page
- Unpack it into a directory named `vscode`
- move that directory into `/opt`

## emacs setup
- Download the desired emacs version found https://ftp.gnu.org/pub/gnu/emacs/. 26.3 seems to work
- `tar -zxvf emacs-VERSION.tar.gz`
- `cd emacs-VERSION`
- `./configure --with-x-toolkit=no # you may need to install other packages (ex libjpg) for this to work`
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
6. `cd emacs.d/helm`
7. `make`
8. `sudo make install`
9. `cd ../eply`
10. `pip install .`
