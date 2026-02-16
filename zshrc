SCRIPT_PATH="${${(%):-%N}:A}"
SCRIPT_DIR="$(cd "$(dirname "${SCRIPT_PATH}")" && pwd)"

for file in "${SCRIPT_DIR}"/zshrc.d/*.zsh(N); do
    [ -f "${file}" ] && source "${file}"
done

for file in "${SCRIPT_DIR}"/local/zsh/*.zsh(N); do
    [ -f "${file}" ] && source "${file}"
done
