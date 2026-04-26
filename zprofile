SCRIPT_PATH="${${(%):-%N}:A}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"

# 共通設定の読み込み
if [ -f "${SCRIPT_DIR}/zshrc.d/zprofile.sh" ]; then
    source "${SCRIPT_DIR}/zshrc.d/zprofile.sh"
fi

# デバイス固有の設定の読み込み
if [ -f "${SCRIPT_DIR}/local/zsh/zprofile.zsh" ]; then
    source "${SCRIPT_DIR}/local/zsh/zprofile.zsh"
fi