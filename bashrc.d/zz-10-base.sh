s=10000 # increasing the number of commands back you can go in history
export HISTSIZE=$s
export HISTFILESIZE=$s
export PATH="$HOME/bin:$PATH"
export PS1="\W$ "


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/carlin/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/carlin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/carlin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/carlin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
export PATH=/opt/homebrew/bin:$PATH
