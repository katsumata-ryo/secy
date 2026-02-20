# 作業フロー

## プロジェクト開始時

### 計画中

- プロジェクト開始と要求作成: Product Owner
- 仕様設計・技術選定: Lead Engineer と Product Owner
- 設計書からの Issue 分解: Lead Engineer

### 実装中

- 着手順の決定: Product Owner（必要に応じて Lead Engineer に移譲）
- タスクアサイン: Lead Engineer -> Engineer
- タスク計画: Engineer
- 計画レビュー: Engineer -> Lead Engineer
- タスク実装: Engineer
- PR レビュー: Engineer -> Lead Engineer（必要時 Product Owner も確認）
- マージ: Product Owner（将来的に Lead Engineer へ移譲）

## 完了条件検証プロセス

「タスクが終わった」ではなく「完了条件が満たされた」まで確認する。

1. 元の Issue / タスクの目的を達成している
2. ローカルテスト（TypeScript、ESLint、RSpec など）が通る
3. CI が実際に通っている（pass を確認）
4. 副作用や新しい問題が発生していない
5. レビューコメントに適切に返信した  
   GitHub の Codex レビューには `@codex` メンションを付ける

## 進捗報告

- PR 単位で報告する（Issue ごとにブランチを切り、PR 作成時に報告）
- Engineer -> Lead Engineer の報告はコミット単位で共有する
- バックグラウンドタスク投入時は「N タスク並列実行中」を即時共有する
- 長時間無言にならないよう中間報告を挟む

## ドキュメント運用

- 引き継ぎ記録: `docs/tmp/handover.md`
- 設計・Issue 計画: `docs/plans/`
  - 命名規則: `<Issue番号>-<英語で名前>.md`
- 開発中の学び: `docs/notes/`
  - 形式: 概要・課題・状況・解決策（採用しなかった案があれば併記）・結果

## コンテキスト引き継ぎ

- セッション終了前またはコンテキスト上限が近づいたら `docs/tmp/handover.md` を更新する
- プロジェクト全体像・進捗・次アクションを記録する
- 次セッション開始時に `handover.md` を読み、続きから作業する
