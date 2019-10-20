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

for f in gitconfig netrc; do
    dst="$HOME"/.$f
    if [[ -e $dst ]]; then
        continue
    fi
    if [[ -L $dst ]]; then
        rm "$dst"
    fi
    src=$PWD/template/$f
    if [[ -r $src ]]; then
        echo "Copying template to $dst; YOU NEED TO EDIT IT."
	install -m 0600 "$src" "$dst"
    fi
done


linux() {
    # only need vscode in xwindow env
    if xset q &>/dev/null; then
        dst="/opt/vscode/data"
        if [ -e $dst ]; then
            rm -rf "$dst"
        else
            ln -sf "$HOME/src/e-carlin/home-env/vscode.d" "$dst"
        fi
        sudo ln -sf "/opt/vscode/bin/code" "/usr/bin"
    fi
}

darwin() {
    dst="/Applications/code-portable-data"
    if [ -e $dst ]; then
        rm -rf "$dst"
    else
        ln -sf "$HOME/src/e-carlin/home-env/vscode.d" "$dst"
    fi
}


readonly OS="$(uname -a | cut -d ' ' -f1)"
if [[ "${OS}" = "Linux" ]]; then
    linux
elif [[ "$OS" = "Darwin" ]]; then
    darwin
else
    echo "$OS unrecognized"
    exit 1
fi
unset -f linux
unset -f darwin