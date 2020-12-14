alias d_container_id="docker ps | cut -f1 -d ' ' | awk 'NR==2{printf \"%s\", \$1}' | xclip -selection c"
alias g_files_in_commit="git diff-tree --no-commit-id --name-only -r"
alias gb="git branch --sort=committerdate"
alias gbg="git branch | grep -i"
alias gcam="git commit -a -m"
alias gch="git checkout"
alias gd="git diff --color"
alias gg="git log --graph --decorate --simplify-by-decoration --oneline"
alias gl="git log --abbrev-commit --pretty=oneline"
alias gs="git status"
alias k="clear"
alias grep="grep --color=auto"
# OSX uses BSD ls which supports -G for color
ls --color=auto &> /dev/null && alias ls='ls --color=auto' || alias ls='ls -G'
alias la="ls -A"
alias ll='ls -l --hide="*.pyc" --block-size=M'
alias reset_keymap="setxkbmap -layout us"
alias sbp="source ~/.bash_profile"

function g_delete_branches() {
    if [[ $1 == '-c' ]]; then
        git checkout master && git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d
        git remote prune origin
    else
        git checkout master && git branch --merged | egrep -v "(^\*|master)"
    fi
}
export -f g_delete_branches

# From: https://github.com/biviosoftware/home-env/blob/master/bashrc.d/zz-10-base.sh#L296
function g() {
    local x="$1"
    shift
    # *~ is emacs backup file
    # #* is emacs autosave file
    grep -iIrn --exclude-dir='.git' --exclude='*~' --exclude='#*' \
       "$x" "${@-.}"   2>/dev/null
}
export -f g

function gp() {
    if git push "$@" ; then
        return
    fi
    local b=$(git rev-parse --abbrev-ref HEAD)
    if ! git config --get "branch.$b.merge" ; then
        git push --set-upstream origin "$b"
    fi
}
export -f gp

function gpy() {
    # can't use g() because --exclude's override --include
    grep -iIrn$2 --include="*.py" "$1"  .
}
export -f gpy


function gext() {
    g "$1"  --exclude-dir="ext" .
}
export -f gext

#TODO(e-carlin): this doesn't work right on macos
function gps() {
    local x=$1
    ps auxww | grep -i "[${x:0:1}]${x[@]:1}"
}
export -f gps

function gsump() {
   g --exclude-dir="Arduino" "$@"
}
export -f gsump

#TODO(e-carlin): this doesn't work right on macos
function pstree() {
    ps axf
}
export -f pstree

function pscpu(){
    ps auxww --sort=-pcpu | head -n 10
}
export -f pscpu

function findd() {
    find . -type f -name "$1" -exec rm -f '{}' \;
}
export -f findd

function findn() {
    local path="$1"
    local name="$2"
    if [[ -z "$2" ]]; then
        path="."
        name="$1"
    fi
    # stderr redirection makes it so permission denied errors are not displayed
   find "$path" -iname "*$name*" -not -name "*.pyc" 2>/dev/null
}
export -f findn

function sirepo_pr_comments() {
    curl -s "https://api.github.com/repositories/37476480/pulls/$1/comments" | jq .[].body | sed G > c.txt
    echo 'results in c.txt'
}
export -f sirepo_pr_comments
