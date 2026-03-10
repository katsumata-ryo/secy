# frozen_string_literal: true

require "spec_helper"
require "tempfile"

RSpec.describe Secy::TemplateRenderer do
  describe "#render" do
    it "replaces template variables" do
      file = Tempfile.new("template")
      file.write("Hello {{PROJECT_NAME}}!")
      file.close

      renderer = described_class.new("{{PROJECT_NAME}}" => "my-app")
      result = renderer.render(file.path)

      expect(result).to eq("Hello my-app!")
    ensure
      file.unlink
    end

    it "replaces multiple variables" do
      file = Tempfile.new("template")
      file.write("{{PROJECT_NAME}} has {{MEMBERS_TABLE}}")
      file.close

      renderer = described_class.new(
        "{{PROJECT_NAME}}" => "my-app",
        "{{MEMBERS_TABLE}}" => "| Alice |"
      )
      result = renderer.render(file.path)

      expect(result).to eq("my-app has | Alice |")
    ensure
      file.unlink
    end

    it "returns content unchanged when no variables match" do
      file = Tempfile.new("template")
      file.write("No variables here")
      file.close

      renderer = described_class.new("{{PROJECT_NAME}}" => "my-app")
      result = renderer.render(file.path)

      expect(result).to eq("No variables here")
    ensure
      file.unlink
    end
  end
end
