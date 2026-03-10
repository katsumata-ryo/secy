# secy

AI協働開発プロジェクトのテンプレート展開ツール。`secy init` で personal / team の2モードからテンプレートを配置する。

## インストール

```bash
gem install secy
```

## 使い方

```bash
# 新プロジェクトのディレクトリで実行
mkdir my-project && cd my-project
secy init
```

対話式でモード（personal / team）とプロジェクト名を選択し、テンプレートが配置される。

### モード

- **personal** - 個人開発（AIペアプロ）。シンプルな構成
- **team** - チーム開発（Claude Code + Codex + Gemini のマルチAI協業）。メンバー設定・ペインID管理あり

## 配置されるファイル

### 共通（両モード）

```
.claude/settings.json                # Claude Code 設定
.claude/skills/handover/SKILL.md     # /handover コマンド
.claude/skills/refresh/SKILL.md      # /refresh コマンド
docs/tmp/handover.md                 # セッション引き継ぎ記録
```

### personal モード

```
CLAUDE.md                            # AIペアプロガイドライン
.claude/hooks/session-start.sh       # セッション開始フック
docs/working-agreements/
  README.md / engineering-rules.md / workflow.md
```

### team モード

```
CLAUDE.md                            # AI協業ガイドライン
AGENTS.md                            # Codex 専用ガイドライン
.claude/hooks/session-start.sh       # セッション開始フック
docs/working-agreements/
  README.md / team-collaboration.md / engineering-rules.md / workflow.md
```

## テンプレート変数

| プレースホルダー | 内容 | モード |
|---|---|---|
| `{{PROJECT_NAME}}` | プロジェクト名 | 両方 |
| `{{MEMBERS_TABLE}}` | メンバー表（名前・モデル・役割） | team |
| `{{PANE_TABLE}}` | WezTerm ペインID 表 | team |

## 開発

```bash
git clone https://github.com/katsumata-ryo/secy.git
cd secy
bundle install
bundle exec rspec
```
