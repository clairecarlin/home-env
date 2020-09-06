#!/bin/bash

set -euo pipefail

function main() {
    if emacs --version > /dev/null 2>&1; then
        echo "Existing emacs found please uninstall"
        exit 1
    fi

    if ! pkg-config --version > /dev/null 2>&1; then
       echo "pkg-config not installed"
       exit 1
    fi

    if ! pkg-config --exists "jansson >= 2.7" > /dev/null 2>&1; then
        echo "jansson not found. Need to install (ex yum install jansson-devel)"
        exit 1
    fi

    cd ~
    if [[ ! -f emacs-27.1.tar.gz || ! -d emacs-27.1 ]]; then
       wget https://ftp.gnu.org/pub/gnu/emacs/emacs-27.1.tar.gz
       tar -zxf emacs-27.1.tar.gz
    fi
    cd emacs-27.1
    ./configure --with-x-toolkit=no --without-x
    make
    echo 'cd ~/emacs-27.1 && sudo make install'
}

main
