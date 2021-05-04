alias d_container_id="docker ps | cut -f1 -d ' ' | awk 'NR==2{printf \"%s\", \$1}' | xclip -selection c"
alias g_files_in_commit="git diff-tree --no-commit-id --name-only -r"
alias gbg="git branch | grep -i"
alias gcam="git commit -a -m"
alias gch="git checkout"
alias gd="git diff --color"
alias gg="git log --graph --decorate --simplify-by-decoration --oneline"
alias gll="git log --abbrev-commit --pretty=oneline"
alias gl="gll | head"
alias gs="git status"
alias k="clear"
alias grep="grep --color=auto"
alias reset_keymap="setxkbmap -layout us"
alias sbp="source ~/.bash_profile"

# macOS uses BSD ls try to use GNU ls which long options
if ! ls --color=auto &> /dev/null && [ ! -s /usr/local/opt/coreutils/libexec/gnubin/ls ]; then
    echo '** only BSD `ls` found. Maybe run `brew install coreutils` **'
else
    alias gls='ls --color=auto'
    [ -s /usr/local/opt/coreutils/libexec/gnubin/ls ] && alias gls='/usr/local/opt/coreutils/libexec/gnubin/ls --color=auto'
    alias la="gls -A"
    alias ll='gls -lah --hide="*.pyc"'
fi

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

function g_delete_branches() {
    if [[ $1 == '-c' ]]; then
        git checkout master && git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d
        git remote prune origin
    else
        git checkout master && git branch --merged | egrep -v "(^\*|master)"
    fi
}
export -f g_delete_branches

function gb() {
    PS3="Enter number of branch to checkout: "
    # Need to use --format because normal `git branch` shows a * next to the
    # current branch which will be expanded by bash to list files in $PWD
    select b in $(git branch --format='%(refname:short)' --sort=committerdate)
    do
        gch "$b"
        break
    done
}
export -f gb

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
   find "$path" -ipath "*$name*" -not -name "*.pyc" -not -type d 2>/dev/null
}
export -f findn

function findsr() {
    findn ~/src/radiasoft/sirepo/run "$1*/sirepo-data.json"
}
export -f findsr

function sirepo_pr_comments() {
    curl -s "https://api.github.com/repositories/37476480/pulls/$1/comments" | jq .[].body | sed G > c.txt
    echo 'results in c.txt'
}
export -f sirepo_pr_comments
