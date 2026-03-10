# frozen_string_literal: true

module Secy
  class TemplateRenderer
    def initialize(variables = {})
      @variables = variables
    end

    def render(template_path)
      content = File.read(template_path)
      @variables.each { |key, value| content = content.gsub(key, value) }
      content
    end
  end
end
