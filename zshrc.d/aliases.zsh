function alias_if_exists() {
    local key="$1"
    local alias_cmd="$2"
    local cmd="${3:-}"
    local alternative_cmd="${4:-}"

    if [[ -z "$cmd" ]]; then
        alias "${key}=${alias_cmd}"
    elif command -v "$cmd" > /dev/null 2>&1; then
        alias "${key}=${alias_cmd}"
    elif [[ -n "$alternative_cmd" ]]; then
        alias "${key}=${alternative_cmd}"
    fi
}

function _fzf_change_directory() {
  local list_cmd="$1"
  local base_cmd="$2"
  local selected
  local base_dir
  selected=$(eval "$list_cmd" | fzf-tmux ${FZF_TMUX_OPTS:-})
  if [ -n "$selected" ]; then
    base_dir=$(eval "$base_cmd")
    cd "$base_dir/$selected"
  fi
}

function pysw(){
  local selected
  selected=$(mise ls python --installed | awk 'NR>1 {print $2}' | fzf)
  if [ -n "$selected" ]; then
    mise use -g python@$selected
  fi
}

function quit() {
    if builtin command -v gpgconf > /dev/null 2>&1; then
        gpgconf --kill gpg-agent
    fi
    exit
}

function reload() {
    source "${HOME}/.zshrc"
}

# alias_if_exists 'cdc'       '_fzf_change_directory "ls -1D" "pwd"'
# alias_if_exists 'cdf'       'cd $(find . -name "*" -type d | fzf)' 'fzf'
# alias_if_exists 'cdg'       '_fzf_change_directory "ghq list" "ghq root"' 'ghq'
# alias_if_exists 'cdot'      'cd $HOME/.dotfiles'
# alias_if_exists 'cdr'       'cd -'
# alias_if_exists 'cdocs'     'cd $HOME/docs/obsidian'
# alias_if_exists 'cdw'       '_fzf_change_directory "ls -1D $HOME/dev/workspaces" "echo $HOME/dev/workspaces"'
# alias_if_exists 'dk'        'docker'          'docker'
# alias_if_exists 'g'         'git'             'git'
alias_if_exists 'll'        'eza -al --group-directories-first' 'eza' 'ls -la'
alias_if_exists 'ls'        'eza -a --group-directories-first'  'eza' 'ls -a'
# alias_if_exists 'q'         'quit'
alias_if_exists 'reload'    'exec -l zsh'
# alias_if_exists 'rm'        'rm -i'
# alias_if_exists 'rr'        'rm -ir'
# alias_if_exists 'rrf'       'rm -fr'
# alias_if_exists 'tf'        'terraform'
alias_if_exists '..'         'cd ../'
alias_if_exists '...'        'cd ../../'
alias_if_exists '....'       'cd ../../../'
alias_if_exists '......'      'cd ../../../../'
# alias_if_exists 'pgcli'     'pgcli --auto-vertical-output' 'pgcli'
# alias_if_exists 'pysw'      'pysw'
# alias_if_exists 'epochtime' 'date +%s'
# alias_if_exists 'dive-mine' 'ssh miya10kei@192.168.1.217'
# alias_if_exists 'env'       'env | sort'
