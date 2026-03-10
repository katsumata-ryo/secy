# frozen_string_literal: true

require "thor"
require_relative "../secy"
require_relative "initializer"

module Secy
  class CLI < Thor
    desc "init", "AI協働開発プロジェクトのテンプレートを配置する"
    def init
      Secy::Initializer.new.run
    end

    desc "version", "バージョンを表示する"
    def version
      puts "secy #{Secy::VERSION}"
    end

    def self.exit_on_failure?
      true
    end
  end
end
