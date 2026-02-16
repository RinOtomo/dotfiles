# Claude Shared Config

このディレクトリは Claude 用の共通設定を管理します。

## 含まれるファイル
- `CLAUDE.md`: 日本語での実務利用を前提にした共通指示

## 適用方法
`init.sh` でディレクトリごと `~/.claude` にシンボリックリンクします。

```sh
./init.sh claude
# or
./init.sh init
```

適用後の参照先:
- `~/.claude -> <dotfiles>/config/claude`
