g() {
    local x="$1"
    shift
    grep -iIr --exclude-dir='.git' --exclude='*~' --exclude='.#*' --exclude='*/.#*' \
        "$x" "${@-.}" 2>/dev/null
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# TODO(e-carlin): Fix. Recognize xwindow and only enable then
# readonly OS="$(uname -a | cut -d ' ' -f1)"
# if [[ "${OS}" = "Linux" ]]; then
#    xmodmap ~/.Xmodmap
# fi

export EDITOR=$(type -p nvim)
export PAGER=$(type -p less)
export PROMPT_COMMAND=""
export PS1="\W\$(parse_git_branch)$ "
export TERM=xterm-256color
