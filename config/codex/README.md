# Codex Shared Config

このディレクトリは、`codex` CLI の共通設定を管理します。

## 含まれるファイル
- `config.toml`: Codex 本体の共通デフォルト設定
- `AGENTS.md`: 日本語で実務利用しやすくするための追加指示

## 適用方法
このリポジトリでは `init.sh` から `~/.codex` へディレクトリごとシンボリックリンクします。

```sh
./init.sh codex
# or
./init.sh init
```

適用後の参照先:
- `~/.codex -> <dotfiles>/config/codex`

## 使い方例
- 安全重視: `codex -p safe`
- 速度重視: `codex -p fast`
- 深掘り重視: `codex -p deep`

必要に応じて一時上書きできます。

```sh
codex -c model_reasoning_effort="high"
```
