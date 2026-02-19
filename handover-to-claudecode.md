# Handover: agentfiles セットアップ

## プロジェクト概要

AI協業開発（Claude Code + Codex + Gemini）の共通テンプレートを管理する `agentfiles` リポジトリを作る。
新しいプロジェクトを始めるときに `init.rb` を叩くと、対話式にテンプレートファイルが配置される仕組み。

## 現状

クロロ（Claude.ai）とリョウで設計・ファイル生成まで完了。
ファイルはダウンロード済みのはずなので、それをGitHubリポジトリに上げるところから作業開始。

## ファイル構成

```
agentfiles/
  init.rb                              ← curl で叩くメインスクリプト
  templates/
    CLAUDE.md                          ← {{MEMBERS_TABLE}} {{PANE_TABLE}} を変数置換
    README.md                          ← {{PROJECT_NAME}} を変数置換
    .claude/
      hooks/
        session-start.sh               ← {{PROJECT_NAME}} を変数置換
      skills/
        handover/SKILL.md
        refresh/SKILL.md
    docs/
      tmp/
        handover.md                    ← {{PROJECT_NAME}} を変数置換
```

## init.rb の動き

1. プロジェクト名を質問
2. デフォルトメンバー構成を使うか質問（使わない場合は人数・名前・モデル・役割を入力）
3. GitHubのrawからテンプレートファイルを取得（ローカルにtemplatesディレクトリがあればそちら優先）
4. 変数置換してカレントディレクトリに配置
5. session-start.sh に実行権限を付与

## 変数プレースホルダー一覧

| プレースホルダー | 内容 |
|---|---|
| `{{PROJECT_NAME}}` | プロジェクト名 |
| `{{MEMBERS_TABLE}}` | メンバー表（Markdown table） |
| `{{PANE_TABLE}}` | WezTermペインID表（IDは空白、名前だけ入る） |

## 次にやること

1. GitHubに `agentfiles` リポジトリを作成（privateでOK）
2. ダウンロードしたファイルをリポジトリに配置してpush
3. `init.rb` の `YOUR_USERNAME` を実際のGitHubユーザー名に書き換える
4. 実際のプロジェクトで `curl | ruby` を叩いて動作確認

## 使い方（完成後）

```bash
# 新プロジェクトのディレクトリで叩く
curl -fsSL https://raw.githubusercontent.com/YOUR_USERNAME/agentfiles/main/init.rb | ruby
```

## 備考

- ペインIDは init.rb では設定せず、配置後に `wezterm cli list` で確認して手動で CLAUDE.md に記入する方針
- 将来的にはメンバー構成（名前・モデル）もアップデートしやすいように、テンプレート側だけ変えれば良い設計になっている
- 個人用途なのでハードコード箇所が多いが、それで十分
