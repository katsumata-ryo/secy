# frozen_string_literal: true

require_relative "lib/secy/version"

Gem::Specification.new do |spec|
  spec.name = "secy"
  spec.version = Secy::VERSION
  spec.authors = ["katsumata-ryo"]
  spec.summary = "AI協働開発プロジェクトのテンプレート展開ツール"
  spec.description = "Claude Code / Codex / Gemini によるマルチAIチーム向けプロジェクトスキャフォールドツール"
  spec.homepage = "https://github.com/katsumata-ryo/secy"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.files = Dir["lib/**/*.rb", "templates/**/*", "exe/*"]
  spec.bindir = "exe"
  spec.executables = ["secy"]

  spec.add_dependency "thor", "~> 1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
end
