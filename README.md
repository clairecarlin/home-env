## home-env
This repository configures my "home environment" on all machines
(personal and work). It configures dotfiles (ex .bashrc) as well as
manages packages for editors (ex ctrlp for vim). It also sets up
useful shell functions and aliases.

This repository was inspired by (and copy/pasted from) [biviosoftware
home-env](https://github.com/biviosoftware/home-env).

To install: `curl -s -L
https://git.sr.ht/~e-carlin/home-env/blob/master/install.sh | bash`

## TODO tracker
Available [here](https://todo.sr.ht/~e-carlin/home-env).

## OS
I work on macOS, Ubuntu, Fedora, and CentOS. My configuration should
work across all of those systems

### macOS
- To swap left ctrl and alt keys use
[karabiner](https://pqrs.org/osx/karabiner/).  Specifically I do:
left\_alt (equal to \`left_option\`) to left\_control and
left\_control to left\_option
- In iTerm2 I swap [right alt with
esc+](https://www.iterm2.com/faq.html) ( search for "esc+").
- I use the gui version of emacs because it comes with image support
  https://emacsformacosx.com/ but it needs to be started from terminal
  (`emacs`) to properly load my env (something to do with sourcing
  correct dotfiles)
- if you can't `ls ~/Downloads` then you need to give fully disk
  access to system ruby (system prefs -> privacy and security -> full
  disk acces -> CMD + shft + G -> /usr/bin/ruby)
- [Fix quote
  characters](https://osxdaily.com/2014/04/10/change-quote-style-mac-os-x/)

### Brew (multiuser)
- System preferences > users and groups > + icon > new group (named
  brew)
- add user(s) to this group
- install brew
- `chgrp -R brew $(brew --prefix)/*` # make brew owned by brew group
- `chmod -R g+w $(brew --prefix)/* ` # Allow members read and write
  privs
- ** `sudo chown -R ${USER}:brew $(brew --prefix)/*` ** # Brew is
  messed up, may have to run this as the user before running any brew
  commands
- `brew install coreutils` # Things like gnu ls which supports the
  --hide flag
- `brew install bash` # update to newer bash
  https://www.shell-tips.com/mac/upgrade-bash/

### Ubuntu
- [Remove terminal
  transparency](https://askubuntu.com/questions/1076036/how-to-remove-all-window-transparency-effects)
- `sudo kbdrate -r 30 -d 250` # Make keys go brrr
- `Windows + p` # Cycle through display settings to get to mirror
  display
- `sudo apt update && sudo apt upgrade -y` # Update machine

## Firefox
- I prefer to cycle through tabs in order not most recently used. To
do so enter `about:config` in the address bar, type ctrl in the search
box, double click `browser.ctrlTab.previews` so it's value becomes
`false`.


## Editor
Emacs is my main editor. I use a "resonably up to date version". See
install-emacs.sh for the specific version and how to install
### Useful emacs commands during install/setup:
- `M-x eval-expression RET (functionp 'json-serialize) RET ;(should be
  t)`
- `M-x lsp-python-ms-update-server`
- rm dirs in emacs.d/melpa then eval-buffer
e-carlin-pack-install-helper.el (make sure that file has up to date
packages found in dot/emacs)
- `M-x toggle-debug-on-error`
### Debugging emacs
- `M-x toggle-debug-on-error ;; or on-quit`
- `d ;; steps through in the debugger`
- `c ;; continues execution in the debugger`
- If you find the function in question and want to monkey around with
  it you can copy and paste it into a scratch buffer and the run `M-x
  eval-buffer`. Emacs has a global namespace so the function will
  override the default one.
### Running elisp
- M-x eval-buffer
- M-x byte-compile-file

### EIN (emacs ipython notebook)
- For runninging jupyter notebooks with emacs
  https://realpython.com/emacs-the-best-python-editor/#integration-with-jupyter-and-ipython

### Other editor options
At times I also use vi (vim). I have configuration here for it.

Previously I used neovim and vscode so if you search the git history
you can see how I had them setup.

## Keyboard
### Kinesis Freestyl Pro
- Sometimes on Ubuntu alt and windows key seem to get swapped in that
  case press the "Layout" 2x (once 2 layout lights will show up, press
  once more one layout light will be lit)

## GPG
- Creation instructions:
https://www.liquidweb.com/kb/how-do-i-use-gpg/ `gpg
--full-generate-key # rsa/rsa; 4096` `gpg --output public.asc --armor
--export <email>` `gpg --output private.asc --armor
--export-secret-keys --export-options export-backup <email>` `gpg
—-import /path/to/private.asc`

### Assymetric encryption
`gpg --output test.gpg --encrypt --sign --armor --recipient <email>
test.txt` `gpg --output test.txt --decrypt test.gpg`

### Symmetric encryption
`gpg --symmetric test.txt` `gpg --decrypt test.txt.gpg > test.out`

### Managing usb on macos
`diskutil list` `diskutil eraseDisk FAT32 KINGSTON MBRFormat
/dev/disk2`

## Setup instructions
```bash
mkdir -p ~/src/e-carlin
cd $_
git clone --recursive git@git.sr.ht:~e-carlin/home-env
cd home-env
bash install.sh
exec bash
```
