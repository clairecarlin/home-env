linux() {
# TODO(e-carlin): Fix. Recognize xwindow and only enable then
#    xmodmap ~/.Xmodmap
    ln -s "/opt/vscode/bin/code" "/usr/bin"
    ln -s "$HOME_ENV_BASE/vscode.d/" "/opt/vscode/data"
}

readonly OS="$(uname -a | cut -d ' ' -f1)"
if [[ "${OS}" = "Linux" ]]; then
    linux
fi