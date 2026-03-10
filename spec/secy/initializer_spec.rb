# frozen_string_literal: true

require "spec_helper"

RSpec.describe Secy::Initializer do
  describe "constants" do
    it "defines valid modes" do
      expect(Secy::Initializer::MODES).to eq(%w[personal team])
    end

    it "lists shared files" do
      expect(Secy::Initializer::SHARED_FILES).to include(".claude/settings.json")
      expect(Secy::Initializer::SHARED_FILES).to include("docs/tmp/handover.md")
    end

    it "lists team-specific files" do
      expect(Secy::Initializer::TEAM_FILES).to include("AGENTS.md")
      expect(Secy::Initializer::TEAM_FILES).to include("docs/working-agreements/team-collaboration.md")
    end

    it "lists personal-specific files without team-collaboration" do
      expect(Secy::Initializer::PERSONAL_FILES).to include("CLAUDE.md")
      expect(Secy::Initializer::PERSONAL_FILES).not_to include("docs/working-agreements/team-collaboration.md")
      expect(Secy::Initializer::PERSONAL_FILES).not_to include("AGENTS.md")
    end
  end

  describe "template files exist" do
    (Secy::Initializer::SHARED_FILES).each do |file|
      it "shared/#{file} exists" do
        path = File.join(Secy::TEMPLATES_DIR, "shared", file)
        expect(File.exist?(path)).to be(true), "Missing: #{path}"
      end
    end

    Secy::Initializer::TEAM_FILES.each do |file|
      it "team/#{file} exists" do
        path = File.join(Secy::TEMPLATES_DIR, "team", file)
        expect(File.exist?(path)).to be(true), "Missing: #{path}"
      end
    end

    Secy::Initializer::PERSONAL_FILES.each do |file|
      it "personal/#{file} exists" do
        path = File.join(Secy::TEMPLATES_DIR, "personal", file)
        expect(File.exist?(path)).to be(true), "Missing: #{path}"
      end
    end
  end
end
