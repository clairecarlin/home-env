#!/bin/bash

set -euo pipefail

function main() {
    if emacs --version; then
        echo "Existing emacs found please uninstall"
        exit 1
    fi

    if ! pkg-config --exists --print-errors "jansson >= 2.7"; then
        echo "jansson not found. Need to install (ex yum install jansson-devel)"
        exit 1
    fi

    cd /tmp
    mkdir e
    cd e
    wget https://ftp.gnu.org/pub/gnu/emacs/emacs-27.1.tar.gz
    tar -zxf emacs-27.1.tar.gz
    cd emacs-27.1
    ./configure --with-x-toolkit=no --without-x
    make
    echo 'cd /tmp/e && sudo make install'
}

main
