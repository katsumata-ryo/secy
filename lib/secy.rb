# frozen_string_literal: true

require_relative "secy/version"

module Secy
  ROOT = File.expand_path("..", __dir__)
  TEMPLATES_DIR = File.join(ROOT, "templates")
end
