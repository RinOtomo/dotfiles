# dotfiles

## Setup (macOS + zsh)

```sh
./init.sh init
```

`init.sh` runs dotfile symlink setup and `brew bundle --file=./Brewfile`.

## Commands

```sh
./init.sh link   # symlink only
./init.sh codex  # Codex shared config only
./init.sh claude # Claude shared config only
./init.sh brew   # Homebrew + managed packages
./init.sh help
```

## Codex Shared Config

Shared Codex settings are stored in `config/codex`.

```sh
./init.sh codex
```

This links:
- `~/.codex -> <dotfiles>/config/codex`

## Claude Shared Config

Shared Claude settings are stored in `config/claude`.

```sh
./init.sh claude
```

This links:
- `~/.claude -> <dotfiles>/config/claude`

## GitHub Repo Search Widget

Set repository base dir in `local/zsh/env.zsh` if needed:

```sh
export GITHUB_REPO_BASE_DIR="$HOME/dev/github"
```
