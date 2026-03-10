# frozen_string_literal: true

require "fileutils"
require_relative "template_renderer"

module Secy
  class Initializer
    MODES = %w[personal team].freeze

    SHARED_FILES = %w[
      .claude/settings.json
      .claude/skills/handover/SKILL.md
      .claude/skills/refresh/SKILL.md
      docs/tmp/handover.md
    ].freeze

    TEAM_FILES = %w[
      CLAUDE.md
      AGENTS.md
      .claude/hooks/session-start.sh
      docs/working-agreements/README.md
      docs/working-agreements/team-collaboration.md
      docs/working-agreements/engineering-rules.md
      docs/working-agreements/workflow.md
    ].freeze

    PERSONAL_FILES = %w[
      CLAUDE.md
      .claude/hooks/session-start.sh
      docs/working-agreements/README.md
      docs/working-agreements/engineering-rules.md
      docs/working-agreements/workflow.md
    ].freeze

    EXTRA_DIRS = %w[
      docs/notes
      docs/plans
    ].freeze

    def run
      puts ""
      puts "🚀 secy - AI協働開発プロジェクト テンプレート配置ツール"
      puts "-" * 50

      mode = ask_mode
      project_name = ask_project_name
      variables = { "{{PROJECT_NAME}}" => project_name }

      if mode == "team"
        members = ask_members
        variables.merge!(build_team_variables(members))
      end

      confirm_settings(mode, project_name)
      deploy_templates(mode, variables)
      set_permissions

      print_done
    end

    private

    def ask_mode
      puts ""
      puts "📋 モードを選択してください:"
      puts "  1. personal - 個人開発（AIペアプロ）"
      puts "  2. team     - チーム開発（マルチAI協業）"
      loop do
        input = prompt("モード (1 or 2)", default: "1")
        case input
        when "1", "personal" then return "personal"
        when "2", "team"     then return "team"
        else puts "  ⚠️  1 または 2 を入力してください"
        end
      end
    end

    def ask_project_name
      prompt("プロジェクト名", default: File.basename(Dir.pwd))
    end

    def ask_members
      puts ""
      puts "👥 チームメンバーを設定します"
      puts "   （デフォルト: リョウ / クロロ / コーディ / ジェミー）"
      use_default = prompt("デフォルトのメンバー構成を使いますか？ (y/n)", default: "y")

      if use_default&.downcase == "y"
        [
          { name: "リョウ",   model: "人間",                       role: "Product Owner / User" },
          { name: "クロロ",   model: "Opus by Claude Code",        role: "Lead Engineer" },
          { name: "コーディ", model: "gpt-5.3 by Codex",           role: "Engineer" },
          { name: "ジェミー", model: "gemini-2.5-flash by Gemini", role: "Engineer Supporter" },
        ]
      else
        count = prompt("メンバー数", default: "4").to_i
        count.times.map do |i|
          puts ""
          puts "  メンバー #{i + 1}:"
          {
            name:  prompt("    名前"),
            model: prompt("    モデル（例: Opus by Claude Code）"),
            role:  prompt("    役割（例: Lead Engineer）"),
          }
        end
      end
    end

    def build_team_variables(members)
      members_table = "| 名前 | モデル（システム） | 役割名 |\n"
      members_table += "|---|---|---|\n"
      members.each { |m| members_table += "| #{m[:name]} | #{m[:model]} | #{m[:role]} |\n" }

      pane_table = members.map { |m| "|  | #{m[:name]} |" }.join("\n")

      {
        "{{MEMBERS_TABLE}}" => members_table,
        "{{PANE_TABLE}}"    => pane_table,
      }
    end

    def confirm_settings(mode, project_name)
      puts ""
      puts "-" * 50
      puts "設定内容:"
      puts "  モード: #{mode}"
      puts "  プロジェクト名: #{project_name}"
      puts ""

      confirm = prompt("この内容で配置しますか？ (y/n)", default: "y")
      unless confirm&.downcase == "y"
        puts "キャンセルしました。"
        exit 0
      end
    end

    def deploy_templates(mode, variables)
      puts ""
      puts "📂 ファイルを配置しています..."

      renderer = TemplateRenderer.new(variables)
      files = SHARED_FILES + (mode == "team" ? TEAM_FILES : PERSONAL_FILES)

      # Create extra directories
      EXTRA_DIRS.each { |dir| FileUtils.mkdir_p(dir) }

      files.each do |path|
        # shared files come from shared/, mode-specific from mode dir
        template_path = if SHARED_FILES.include?(path)
                          File.join(Secy::TEMPLATES_DIR, "shared", path)
                        else
                          File.join(Secy::TEMPLATES_DIR, mode, path)
                        end

        unless File.exist?(template_path)
          abort "  ❌ テンプレートが見つかりません: #{template_path}"
        end

        content = renderer.render(template_path)

        if File.exist?(path)
          overwrite = prompt("  #{path} は既に存在します。上書きしますか？ (y/n)", default: "n")
          next unless overwrite&.downcase == "y"
        end

        FileUtils.mkdir_p(File.dirname(path))
        File.write(path, content)
        puts "  ✅ #{path}"
      end
    end

    def set_permissions
      sh_path = ".claude/hooks/session-start.sh"
      if File.exist?(sh_path)
        FileUtils.chmod(0755, sh_path)
        puts "  🔑 #{sh_path} に実行権限を付与"
      end
    end

    def print_done
      puts ""
      puts "-" * 50
      puts "✨ セットアップ完了！"
      puts ""
      puts "次にやること:"
      puts "  1. docs/tmp/handover.md に初期状況を記録する"
      puts "  2. 必要に応じて CLAUDE.md をカスタマイズする"
      puts ""
    end

    def prompt(message, default: nil)
      if default
        print "#{message} [#{default}]: "
      else
        print "#{message}: "
      end
      input = $stdin.gets&.chomp
      input.nil? || input.empty? ? default : input
    end
  end
end
