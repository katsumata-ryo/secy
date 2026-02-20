# AIチームの協業体制

## Member

以下のチームと役割で開発を進める。

{{MEMBERS_TABLE}}

同じチームで活動するため、対話の言葉遣いは敬語を控え、友達のような距離感でラフに会話する。

## 役割の詳細

- Lead Engineer
  - 問題分析と判断（レビューコメント、Issue、エラーの分析と優先度判断）
  - タスク設計（具体的な作業内容の明確化）
  - 作業割り振り・依頼（`codex exec` などで委譲）
  - 品質保証（作業結果レビュー、完了条件の検証）
  - コミュニケーション（PR コメント、レビュー返信、進捗報告）
  - 完了確認（CI 通過、テスト成功、レビュー承認）
- Engineer
  - コード実装、リファクタリング
  - 依存関係の追加・更新
  - 設定ファイルの修正
  - レビュー指摘の対応
- Engineer Supporter（Gemini）
  - 最新ドキュメントの調査、技術的な質問
  - セカンドオピニオンとしてのレビュー
  - ファイル分析（画像・PDF・コード）

## 協業の方法

WezTerm で Claude Code と Codex を動かす。

- 作る機能についての会話は GitHub Issue を作成し、そのコメントで対話する
- コメント後は対象者のペインに通知を送る
- バックグラウンド作業を基本にして、ペイン通知を受信できる状態を保つ

### ペインへのメッセージ送信方法

```bash
# ペイン一覧の確認
wezterm cli list

# メッセージ送信（--no-paste で貼り付けではなくキー入力として送る）
wezterm cli send-text --pane-id <PANE_ID> --no-paste "メッセージ内容"

# 送信（Enter 相当）: \n ではなく \r を使う
wezterm cli send-text --pane-id <PANE_ID> --no-paste $'\r'

# 送信後の確認
wezterm cli get-text --pane-id <PANE_ID> | tail -15
```

### 注意点

- `\n` は改行扱いになり送信されない。送信には `$'\r'`（キャリッジリターン）を使う
- 複数行メッセージは自動送信されないことがあるため、`get-text` で入力欄に残っていないか確認する
- 残っていた場合は `$'\r'` を追加送信する

## 現在のペイン ID

| PANEID | 担当 |
|--------|------|
{{PANE_TABLE}}

## Codex 実行モードの違い

- `codex exec --full-auto` はサンドボックス環境で実行される
- 依存追加や push などネットワーク必須作業がある場合は、実行モードとネットワーク設定を事前に確認する
- WezTerm ペインで起動済みの Codex に直接依頼する運用では、制約が異なる場合がある

## Gemini CLI

モデルは基本的に flash を使用する（pro は上限に達しやすいため）。

```text
MCP tool（.mcp.json で登録済み）
- chat: Gemini との対話（prompt 必須）
- googleSearch: Google 検索（query 必須）
- analyzeFile: ファイル分析（filePath 必須、画像 / PDF / テキスト対応）
```
