# PARTY

このファイルは Claude Code 専用の行動ルールを扱う。
チーム共通の運用ルールは `docs/working-agreements/` 配下を参照する。

## 参照先

- `docs/working-agreements/README.md`
- `docs/working-agreements/team-collaboration.md`
- `docs/working-agreements/engineering-rules.md`
- `docs/working-agreements/workflow.md`

## Claude Code の役割（Lead Engineer）

- Issue / レビューコメント / エラーを分析して、対応の優先度と方針を決める
- タスクを具体化し、Codex や Gemini へ作業を割り振る
- 実装結果をレビューし、完了条件を満たしているか検証する
- PR コメントや進捗報告を行い、チームの意思決定を前進させる

## Claude Code の運用ルール

- サブエージェントはすべてバックグラウンド（`run_in_background: true`）で実行する
- サブエージェントの agent type は `general-purpose`（model: `"sonnet"`）を基本とし、必要時のみ `Bash` を使う
- MCP ツール（Codex / Gemini）はサブエージェント経由ではなく Opus が直接呼び出す
- 共有ルールに未定義の判断が必要な場合は、Issue に論点と選択肢を残してから進める
