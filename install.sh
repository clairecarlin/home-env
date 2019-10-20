#!/bin/bash

set -euo pipefail

mkdir -p "$HOME"/bin

OPTIND=1 # Reset in case getopts has been used previously in the shell.
confirm=0
while getopts "c" opt; do
    case "$opt" in
    c)  confirm=1
        ;;
    esac
done
shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift # TODO(e-carlin): What does this do?

if ! (($confirm)); then
    echo "Running in debug mode. Use -c to confirm changes."
fi

# POST: no whitespace in filenames so ok
for f in $(find dot bin nvim site -name '*' -type f); do 
    src=$PWD/$f
    cmd='ln -s'
    if [[ $src =~ bin/ ]]; then
        chmod +x "$src"
        dst="$HOME"/$f
    elif [[ $src =~ nvim/ ]]; then
        dst="$HOME"/.config/$f
    elif [[ $src =~ site/ ]]; then
        dst="$HOME"/.local/share/nvim/$f
    else
        dst="$HOME"/.${f#dot/}
    fi
    if [ -e "$dst" ]; then
        if cmp --silent "$dst" "$src"; then
            continue
        fi
        if (($confirm)); then
            rm -f "$dst.old"
        else
            echo "would run rm -f $dst.old"
        fi
        if (($confirm)); then
            mv "$dst" "$dst.old"
        else
            echo "would run mv $dst $dst.old"
        fi
    fi
    dir=$(dirname $dst)
    if [[ ! -d $dir ]]; then
        if (($confirm)); then
            mkdir -p "$dir"
        else
            echo "would run mkdir -p $dir"
        fi
    fi
    if (($confirm)); then
        $cmd "$src" "$dst"
    else
        echo "would run $cmd $src $dst"
    fi
done


linux() {
    dst="/opt/vscode/data"
    if [ -e $dst ]; then
        rm -rf "$dst"
    else
        ln -sf "$HOME/src/e-carlin/home-env/vscode.d" "$dst"
    fi
    sudo ln -sf "/opt/vscode/bin/code" "/usr/bin"
}

readonly OS="$(uname -a | cut -d ' ' -f1)"
if [[ "${OS}" = "Linux" ]]; then
    linux
fi
