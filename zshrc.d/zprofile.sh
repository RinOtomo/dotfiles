SCRIPT_PATH="${(%):-%N}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"
DOTFILES_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
export DOTFILES_DIR

# 指定したPATH要素が未登録なら末尾に追加する
path_append_if_missing() {
    local target="${1:A}"
    [[ -d "${target}" ]] || return 0
    [[ ":${PATH}:" == *":${target}:"* ]] && return 0
    export PATH="${PATH:+${PATH}:}${target}"
}

# 指定したPATH要素が未登録なら先頭に追加する
path_prepend_if_missing() {
    local target="${1:A}"
    [[ -d "${target}" ]] || return 0
    [[ ":${PATH}:" == *":${target}:"* ]] && return 0
    export PATH="${target}${PATH:+:${PATH}}"
}

if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# PATH はここに集約して管理する
path_prepend_if_missing "${HOME}/.local/bin"
path_append_if_missing "${HOME}/bin"
path_append_if_missing "${HOME}/.cargo/bin"
path_append_if_missing "${HOME}/.local/share/mise/shims"

# dotfiles で使う共通パス定数
export GITHUB_REPO_SEARCH_ROOT="${HOME}/dev/github"

# 端末固有の環境変数は local 側で上書きする
if [ -f "${DOTFILES_DIR}/local/zsh/env.zsh" ]; then
    source "${DOTFILES_DIR}/local/zsh/env.zsh"
fi
