#!/bin/bash

set -euo pipefail

mkdir -p "$HOME"/bin

# POST: no whitespace in filenames so ok
for f in $(find dot bin nvim site -name '*' -type f); do 
    echo "$f"

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
        rm -f "$dst.old"
	mv "$dst" "$dst.old"
    fi
    dir=$(dirname $dst)
    if [[ ! -d $dir ]]; then
	mkdir -p "$dir"
#        echo "mkdir -p $dir"
    fi
    $cmd "$src" "$dst"
#    echo "$cmd $src $dst"
done
