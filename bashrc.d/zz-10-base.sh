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

# darwin() {

# }
# unset -f darwin

readonly OS="$(uname -a | cut -d ' ' -f1)"
if [[ "${OS}" = "Linux" ]]; then
    linux
fi
unset -f linux


export EDITOR=$(type -p nvim)
export PAGER=$(type -p less)
export PROMPT_COMMAND=""
export PS1="\W\$(parse_git_branch)$ "
export TERM=xterm-256color
