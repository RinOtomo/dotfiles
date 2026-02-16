#!/bin/zsh

# Super simple local repo picker.
# Requires:
# - DOTFILES_DIR from zshrc.d/zprofile.sh
# - GITHUB_REPO_SEARCH_ROOT from local/zsh/env.zsh (or zprofile default)

_github_repo_search() {
  command -v fzf >/dev/null 2>&1 || return 1

  [[ -n "${DOTFILES_DIR:-}" ]] || { echo "github_repo_search: DOTFILES_DIR is not set" >&2; return 1; }
  [[ -n "${GITHUB_REPO_SEARCH_ROOT:-}" ]] || { echo "github_repo_search: GITHUB_REPO_SEARCH_ROOT is not set" >&2; return 1; }

  local root="${GITHUB_REPO_SEARCH_ROOT}"
  local recent_file="${DOTFILES_DIR}/local/zsh/github_repo_recent.txt"
  local selected repo

  mkdir -p "${recent_file:h}" 2>/dev/null

  selected="$({
    [[ -f "$recent_file" ]] && cat "$recent_file"
    find "$root" -type d -name .git -prune 2>/dev/null | sed 's#/.git$##'
  } | awk '!seen[$0]++' | fzf --prompt='Repo > ' --height=70% --layout=reverse)" || return 0

  repo="$selected"
  [[ -d "$repo" ]] || return 0

  {
    print -r -- "$repo"
    [[ -f "$recent_file" ]] && grep -Fxv -- "$repo" "$recent_file"
  } | head -n 200 >| "$recent_file"

  cd "$repo" || return 1
}

zle -N github-repo-search-widget _github_repo_search
bindkey '^G^R' github-repo-search-widget
alias grr='_github_repo_search'
