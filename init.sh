#!/bin/zsh
if [[ "${ZSH_EVAL_CONTEXT:-}" == *:file ]]; then
    echo "[init] Do not source this script. Run: ./init.sh <init|link|brew|help>" >&2
    return 1
fi

SCRIPT_PATH="${(%):-%N}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"
BREWFILE="${SCRIPT_DIR}/Brewfile"

# 初期化ログを見やすくするための共通出力
log() {
    printf '[init] %s\n' "$1"
}

# 既存ファイルを消さずに退避してから置き換える
backup_if_exists() {
    local target="$1"
    local backup_path
    backup_path="${target}.bak.$(date +%Y%m%d%H%M%S)"

    if [[ -e "$target" && ! -L "$target" ]]; then
        mv "$target" "$backup_path"
        log "Backed up ${target} -> ${backup_path}"
    fi
}

link_file() {
    local src="$1"
    local dest="$2"

    backup_if_exists "$dest"
    if [[ -L "$dest" ]]; then
        rm -f "$dest"
    fi
    ln -s "$src" "$dest"
    log "Linked ${dest} -> ${src}"
}

# 端末固有設定の入れ物だけを作成（中身は追跡しない）
ensure_local_dirs() {
    local dir
    for dir in "${SCRIPT_DIR}/local/zsh" "${SCRIPT_DIR}/local/git" "${SCRIPT_DIR}/local/secrets"; do
        mkdir -p "$dir"
        touch "${dir}/.gitkeep"
    done
    log "Ensured local directories exist"
}

# Codex の共通設定ディレクトリをユーザー設定ディレクトリへ反映する
setup_codex_config() {
    link_file "${SCRIPT_DIR}/config/codex" "${HOME}/.codex"
}

# Claude の共通設定ディレクトリをユーザー設定ディレクトリへ反映する
setup_claude_config() {
    link_file "${SCRIPT_DIR}/config/claude" "${HOME}/.claude"
}

# 現在のシェルに brew の PATH を反映する
ensure_brew_shellenv() {
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

# Homebrew が無ければ導入し、あればそのまま利用する
install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        log "Homebrew already installed"
        ensure_brew_shellenv
        return
    fi

    log "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ensure_brew_shellenv
}

# Brewfile を正として一括インストールする
install_brew_packages() {
    if ! command -v brew >/dev/null 2>&1; then
        log "brew command not found"
        return 1
    fi

    if [[ ! -f "${BREWFILE}" ]]; then
        log "Brewfile not found: ${BREWFILE}"
        return 1
    fi

    log "Installing managed Homebrew packages from Brewfile"
    if ! brew bundle --file="${BREWFILE}" --verbose; then
        log "brew bundle failed. Run: brew bundle --file=\"${BREWFILE}\" --verbose"
        return 1
    fi
}

# dotfiles をホーム配下にシンボリックリンクする
link_dotfiles() {
    link_file "${SCRIPT_DIR}/zprofile" "${HOME}/.zprofile"
    link_file "${SCRIPT_DIR}/zshrc" "${HOME}/.zshrc"
}

# 標準の初期化フロー
run_all() {
    ensure_local_dirs
    link_dotfiles
    setup_codex_config
    setup_claude_config
    install_homebrew
    install_brew_packages
    log "Done"
}

usage() {
    cat <<'EOF'
Usage:
  ./init.sh init   # run all initialization steps
  ./init.sh link   # only create symlinks
  ./init.sh codex  # only setup Codex shared config
  ./init.sh claude # only setup Claude shared config
  ./init.sh brew   # only install Homebrew and managed packages
  ./init.sh help   # show this help
EOF
}

main() {
    local cmd="${1:-init}"
    case "$cmd" in
        init)
            run_all
            ;;
        link)
            ensure_local_dirs
            link_dotfiles
            setup_codex_config
            setup_claude_config
            ;;
        codex)
            setup_codex_config
            ;;
        claude)
            setup_claude_config
            ;;
        brew)
            install_homebrew
            install_brew_packages
            ;;
        help|-h|--help)
            usage
            ;;
        *)
            usage
            return 1
            ;;
    esac
}

run_main() {
    emulate -L zsh
    set -euo pipefail
    main "$@"
}

run_main "$@"
