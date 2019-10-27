g() {
    local x="$1"
    shift
    grep -iIr --exclude-dir='.git' --exclude='*~' --exclude='.#*' --exclude='*/.#*' \
        "$x" "${@-.}" 2>/dev/null
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

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

readonly OS="$(uname -a | cut -d ' ' -f1)"
if [[ "${OS}" = "Linux" ]]; then
    linux
elif [[ "${OS}" = "Darwin" ]]; then
    darwin
fi
unset -f linux
unset -f darwin


export EDITOR=$(type -p nvim)
export PAGER=$(type -p less)
export PATH="$PATH:$HOME/bin"
export PROMPT_COMMAND=""
export PS1="\W\$(parse_git_branch)$ "
export TERM=xterm-256color
