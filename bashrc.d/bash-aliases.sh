alias d_container_id="docker ps | cut -f1 -d ' ' | awk 'NR==2{printf \"%s\", \$1}' | xclip -selection c"
alias g_files_in_commit="git diff-tree --no-commit-id --name-only -r"
alias gcam="git commit -a -m"
alias gch="git checkout"
alias gd="git diff"
alias gl="git log --pretty=oneline"
alias gp="git push"
alias gs="git status"
alias k="clear"
alias la="ls -all"
alias ll="ls -l"
alias reset_keymap="setxkbmap -layout us"
alias sbp="source ~/.bash_profile"
alias vim="nvim" # must be before alias v
alias v="vim ."

# From: https://github.com/biviosoftware/home-env/blob/master/bashrc.d/zz-10-base.sh#L296
function g() {
    local x="$1"
    shift
    echo "${@-.}"
    grep -iIrn --exclude-dir='.git' --exclude='*~' --exclude='.#*' --exclude='*/.#*' \
         "$x" --include='*.py'
    #${@-.} 2>/dev/null
}
export -f g

function gpy() {
    local x=$1
    shift
    grep -iIrn --include="*.py"  "$x" .
}
export -f gpy
