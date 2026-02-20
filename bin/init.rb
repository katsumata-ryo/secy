#!/usr/bin/env ruby
# init.rb - AI協業プロジェクトテンプレート配置スクリプト
#
# Usage（dotfilesリポジトリから直接実行）:
#   curl -fsSL https://raw.githubusercontent.com/katsumata-ryo/agent-templates/main/bin/init.rb | ruby
#
# ローカル実行:
#   ruby bin/init.rb

require "fileutils"
require "open-uri"

GITHUB_RAW_BASE = "https://raw.githubusercontent.com/katsumata-ryo/agent-templates/main/templates"

TEMPLATE_FILES = %w[
  CLAUDE.md
  AGENTS.md
  .claude/hooks/session-start.sh
  .claude/skills/handover/SKILL.md
  .claude/skills/refresh/SKILL.md
  docs/working-agreements/README.md
  docs/working-agreements/team-collaboration.md
  docs/working-agreements/engineering-rules.md
  docs/working-agreements/workflow.md
  docs/tmp/handover.md
]

TEMPLATE_DIRS = %w[
  .claude/hooks
  .claude/skills/handover
  .claude/skills/refresh
  docs/notes
  docs/plans
  docs/tmp
  docs/working-agreements
]

# ----------------------------------------
# ユーティリティ
# ----------------------------------------

def prompt(message, default: nil)
  if default
    print "#{message} [#{default}]: "
  else
    print "#{message}: "
  end
  input = $stdin.gets&.chomp
  input.nil? || input.empty? ? default : input
end

def hr
  puts "-" * 50
end

def fetch_template(path)
  # ローカルのtemplatesディレクトリがあればそちらを優先（開発時）
  local_path = File.join(File.dirname(File.dirname(__FILE__)), "templates", path)
  if File.exist?(local_path)
    File.read(local_path)
  else
    URI.open("#{GITHUB_RAW_BASE}/#{path}").read
  end
rescue => e
  puts "  ⚠️  テンプレート取得失敗: #{path} (#{e.message})"
  nil
end

# ----------------------------------------
# 対話式質問
# ----------------------------------------

puts ""
puts "🚀 AI協業プロジェクト テンプレート配置ツール"
hr

# プロジェクト名
project_name = prompt("プロジェクト名", default: File.basename(Dir.pwd))

# メンバー設定
puts ""
puts "👥 チームメンバーを設定します"
puts "   （デフォルト: リョウ / クロロ / コーディ / ジェミー）"
use_default = prompt("デフォルトのメンバー構成を使いますか？ (y/n)", default: "y")

members = []
if use_default&.downcase == "y"
  members = [
    { name: "リョウ",   model: "人間",                    role: "Product Owner / User" },
    { name: "クロロ",   model: "Opus by Claude Code",     role: "Lead Engineer" },
    { name: "コーディ", model: "gpt-5.3 by Codex",        role: "Engineer" },
    { name: "ジェミー", model: "gemini-2.5-flash by Gemini", role: "Engineer Supporter" },
  ]
else
  member_count = prompt("メンバー数", default: "4").to_i
  member_count.times do |i|
    puts ""
    puts "  メンバー #{i + 1}:"
    name  = prompt("    名前")
    model = prompt("    モデル（例: Opus by Claude Code）")
    role  = prompt("    役割（例: Lead Engineer）")
    members << { name: name, model: model, role: role }
  end
end

# ペインIDは空白にしてメンバー名だけ入れておく
puts ""
puts "📟 WezTermペインIDは後で設定できます（今は名前だけ入れておきます）"

hr
puts ""
puts "設定内容:"
puts "  プロジェクト名: #{project_name}"
puts "  メンバー:"
members.each { |m| puts "    - #{m[:name]} / #{m[:model]} / #{m[:role]}" }
puts ""

confirm = prompt("この内容で配置しますか？ (y/n)", default: "y")
unless confirm&.downcase == "y"
  puts "キャンセルしました。"
  exit 0
end

# ----------------------------------------
# テンプレート変数の生成
# ----------------------------------------

# メンバーテーブル
members_table = "| 名前 | モデル（システム） | 役割名 |\n"
members_table += "|---|---|---|\n"
members.each { |m| members_table += "| #{m[:name]} | #{m[:model]} | #{m[:role]} |\n" }

# ペインテーブル（IDは空白）
pane_table = members.map { |m| "|  | #{m[:name]} |" }.join("\n")

variables = {
  "{{PROJECT_NAME}}" => project_name,
  "{{MEMBERS_TABLE}}" => members_table,
  "{{PANE_TABLE}}"   => pane_table,
}

# ----------------------------------------
# ファイル配置
# ----------------------------------------

puts ""
puts "📂 ファイルを配置しています..."

# ディレクトリ作成
TEMPLATE_DIRS.each do |dir|
  FileUtils.mkdir_p(dir)
end

# テンプレート取得・変数置換・配置
TEMPLATE_FILES.each do |path|
  content = fetch_template(path)
  next unless content

  # 変数置換
  variables.each { |k, v| content = content.gsub(k, v) }

  # 既存ファイルの確認
  if File.exist?(path)
    overwrite = prompt("  #{path} は既に存在します。上書きしますか？ (y/n)", default: "n")
    next unless overwrite&.downcase == "y"
  end

  File.write(path, content)
  puts "  ✅ #{path}"
end

# session-start.sh に実行権限を付与
sh_path = ".claude/hooks/session-start.sh"
if File.exist?(sh_path)
  FileUtils.chmod(0755, sh_path)
  puts "  🔑 #{sh_path} に実行権限を付与"
end

# ----------------------------------------
# 完了
# ----------------------------------------

puts ""
hr
puts "✨ セットアップ完了！"
puts ""
puts "次にやること:"
puts "  1. CLAUDE.md のペインIDテーブルを実際のIDで埋める"
puts "     （wezterm cli list で確認）"
puts "  2. README.md にプロジェクトの概要を書く"
puts "  3. docs/tmp/handover.md に初期状況を記録する"
puts ""
