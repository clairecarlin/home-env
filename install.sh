#!/bin/bash
set -euo pipefail


function main() {
    mkdir -p "$HOME"/bin
    mkdir -p "$HOME/src/e-carlin"
    cd "$HOME/src/e-carlin"
    repo="home-env"

    if [[ -d "$repo" ]]; then
        cd "$repo"
        if ! git pull -q; then
	    need_git_creds_message
        fi
    else
        if ! git clone --recursive -q "git@git.sr.ht:~e-carlin/$repo"; then
             need_git_creds_message
        fi
    fi

    cd "$HOME/src/e-carlin/$repo"
    # POSIT: no whitespace in filenames so ok
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
            rm -f "$dst.old"
            mv "$dst" "$dst.old"
        fi
        dir=$(dirname $dst)
        if [[ ! -d $dir ]]; then
            mkdir -p "$dir"
        fi
        $cmd "$src" "$dst"
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
    echo "done"
}

function need_git_creds_message() {
    echo 'eval "$(ssh-agent -s)" && ssh-add ~/.ssh/sr_ht && bash install.sh'
    exit 1
}

main
