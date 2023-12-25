linux() {
    # only use xmodmap if in xwindow env
    if xset q &>/dev/null; then
        xmodmap ~/.Xmodmap
    fi
}

darwin() {
    # Keyboard - enable hold down key to repeat
    defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
    # Keyboard - set a blazingly fast key repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write NSGlobalDomain InitialKeyRepeat -int 10
    # Finder - how all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Finder - show hidden files (not so hidden after all)
    defaults write com.apple.finder AppleShowAllFiles YES
    # Finder - show path bar
    defaults write com.apple.finder ShowPathbar -bool true
    # Finder - when performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    # OS - disable resume system-wide
    defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
}

OS="$(uname -a | cut -d ' ' -f1)"
if [[ "${OS}" == "Linux" ]]; then
    linux
elif [[ "${OS}" == "Darwin" ]]; then
    darwin
fi
unset -f linux
unset -f darwin

function e() {
    emacs "$@"
}
export -f e

if [[ ${INSIDE_EMACS:-} =~ comint ]]; then
    export EDITOR=$(type -p emacsclient)
    export PAGER=ep
    # TODO(e-carlin): We shouldn't really set $TERM, but bivio sets it to dumb
    # when in emacs so this overrides that. We could use
    # (setq comint-terminfo-terminal "xterm-256color") I'm not sure what the
    # correct val for $TERM is iTerm supports xterm-256color so go with that for
    # now.
    export TERM=xterm-256color
    function e(){
        emacsclient "$@"
    }
else
    export EDITOR=$(type -p emacs)
    export PAGER=$(type -p less)
fi

s=10000
export HISTSIZE=$s
export HISTFILESIZE=$s
export PATH="$HOME/bin:$PATH"
