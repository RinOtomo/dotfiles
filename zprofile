SCRIPT_PATH="${${(%):-%N}:A}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"

if [ -f "${SCRIPT_DIR}/zshrc.d/zprofile.sh" ]; then
    source "${SCRIPT_DIR}/zshrc.d/zprofile.sh"
fi
