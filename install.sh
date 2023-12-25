#!/bin/bash
set -euo pipefail

function main() {
    mkdir -p "$HOME"/bin
    cd "$HOME/src/clairecarlin"
    repo="home-env"

    if [[ -d "$repo" ]]; then
        cd "$repo"
        git pull -q
    else
	git clone --recursive -q "https://github.com/clairecarlin/$repo.git"
    fi

    # POSIT: no whitespace in filenames so ok
    for f in $(find dot bin -name '*' -type f); do
        src=$PWD/$f
        cmd='ln -s'
        if [[ $src =~ bin/ ]]; then
            chmod +x "$src"
            dst="$HOME"/$f
        elif [[ $src =~ nvim/ ]]; then
            dst="$HOME"/.config/$f
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
        fi
        $cmd "$src" "$dst"
    done

    for f in template/*; do
        dst="$HOME"/.$(basename $f)
        if [[ -e $dst ]]; then
            continue
        fi
        if [[ -L $dst ]]; then
            rm "$dst"
        fi
        src=$PWD/$f
        if [[ -r $src ]]; then
            echo "Copying template to $dst; YOU MAY NEED TO EDIT IT."
            install -m 0600 "$src" "$dst"
        fi
    done
    echo "done"
}

main
