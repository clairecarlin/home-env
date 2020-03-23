alias d_container_id="docker ps | cut -f1 -d ' ' | awk 'NR==2{printf \"%s\", \$1}' | xclip -selection c"
alias g_files_in_commit="git diff-tree --no-commit-id --name-only -r"
alias gcam="git commit -a -m"
alias gch="git checkout"
alias gd="git diff"
alias gl="git log --pretty=oneline"
alias gp="git push"
alias gs="git status"
alias k="clear"
alias grep="grep --color=auto"
# OSX uses BSD ls which supports -G for color
ls --color=auto &> /dev/null && alias ls='ls --color=auto' || alias ls='ls -G'
alias la="ls -all"
alias ll="ls -l"
alias reset_keymap="setxkbmap -layout us"
alias sbp="source ~/.bash_profile"
alias vim="nvim" # must be before alias v
alias v="vim ."

function delete-branches() {
    if [[ $1 == '-c' ]]; then
        git checkout master && git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d
    else
        git checkout master && git branch --merged | egrep -v "(^\*|master)"
    fi
}
export -f delete-branches

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

function gpy() {
    # can't use g() because --exclude's override --include
    grep -iIrn --include="*.py" "$1"  .
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

#TODO(e-carlin): this doesn't work right on macos
function pstree(){
    ps axf
}
