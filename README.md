# agent-templates

Claude Code + Codex + Gemini による AI 協業開発プロジェクトの共通テンプレートを管理するリポジトリ。

新しいプロジェクトを始めるときに `bin/init.rb` を実行すると、対話式にテンプレートファイルが配置される。

## 使い方

### curl で直接実行

```bash
# 新プロジェクトのディレクトリで実行
curl -fsSL https://raw.githubusercontent.com/katsumata-ryo/agent-templates/main/bin/init.rb | ruby
```

### ローカルで実行

```bash
# このリポジトリをクローン済みの場合
ruby /path/to/agent-templates/bin/init.rb
```

## init.rb の動き

1. プロジェクト名を質問
2. デフォルトのメンバー構成を使うか質問（使わない場合は人数・名前・モデル・役割を入力）
3. GitHub Raw からテンプレートを取得（ローカルに `templates/` があればそちら優先）
4. 変数置換してカレントディレクトリに配置
5. `session-start.sh` に実行権限を付与

## 配置されるファイル

```
<プロジェクト>/
  CLAUDE.md                          # AI 協業ガイドライン（メンバー・ペインID等）
  .claude/
    hooks/
      session-start.sh               # セッション開始時に自動実行
    skills/
      handover/SKILL.md              # /handover コマンド
      refresh/SKILL.md               # /refresh コマンド
  docs/
    notes/                           # 開発メモ
    plans/                           # 設計・Issue 計画
    tmp/
      handover.md                    # セッション引き継ぎ記録
```

## テンプレート変数

| プレースホルダー | 内容 |
|---|---|
| `{{PROJECT_NAME}}` | プロジェクト名 |
| `{{MEMBERS_TABLE}}` | メンバー表（名前・モデル・役割） |
| `{{PANE_TABLE}}` | WezTerm ペインID 表（ID は空白、名前だけ入る） |

## セットアップ後にやること

1. `wezterm cli list` でペイン ID を確認し、`CLAUDE.md` のペインテーブルを埋める
2. `docs/tmp/handover.md` に初期状況を記録する
