## home-env
This repository configures my "home environment" on all machines (personal and
development). It configures dotfiles (ex .bashrc) as well as manages packages 
for editors (ex ctrlp for vim). It also sets up useful shell functions and aliases.

This repository was inspired by and copy and pasted from [biviosoftware
home-env](https://github.com/biviosoftware/home-env).

## Prerequisites
- If you want to use emacs then have emacs installed.
- If you want to use an emacs buffer as your $PAGER in emacs shell then install
ruby. I intend to remove this requirement [sometime in the future](https://github.com/e-carlin/home-env/issues/1).
- If you want to use something like vi then install neovim.
- If you want to use vscode then have it installed.
- If you want copy and paste from emacs to go to your system clipboard install
[xclip](https://github.com/astrand/xclip).
- I like to swap left ctrl and alt keys. On linux systems I use xmodmap and on
macos I use [karabiner](https://pqrs.org/osx/karabiner/).
- If using iTerm swap [right alt with esc+](https://www.iterm2.com/faq.html) (
search for "esc+").

## Setup instructions
*DISCLAIMER:* This installation will overwrite your existing dotfiles and any
other files in it's way. It should move most files to a `*.old` but makes no
guarantees about this. If you are uncomfortable with the possibility of ruining
your existing configuration (or worse) I suggest reading through the sources 
and copying and pasting the things you need. Another option is to fork and 
change what makes sense for you. 
1. `mkdir -p ~/src/e-carlin`
2. `cd $_ && git clone --recursive https://gitlab.com/e-carlin/home-env.git`
3. `cd home-env`
4. `bash install.sh`
5. `cd emacs.d/helm`
6. `make`
7. `sudo make install`
8. `cd ../eply`
9. `pip install .`
