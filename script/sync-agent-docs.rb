# frozen_string_literal: true
# Keep AGENTS.md and .github/copilot-instructions.md in sync.
# Usage: ruby script/sync-agent-docs.rb --check | --sync
require "fileutils"

AGENTS = "AGENTS.md"
COPILOT = ".github/copilot-instructions.md"

def check
  a = File.read(AGENTS)
  c = File.read(COPILOT)
  # copilot file should contain header referencing AGENTS.md
  if c.include?("AGENTS.md") && c.length < a.length
    puts "✓ copilot-instructions.md references AGENTS.md (compressed)"
    exit 0
  else
    warn "✗ copilot-instructions.md drift — run with --sync"
    exit 1
  end
end

def sync
  puts "AGENTS.md is canonical — manually sync copilot file when editing AGENTS.md"
  puts "No auto-sync (keeps compressed copilot summary intentional)."
end

case ARGV.first
when "--check" then check
when "--sync" then sync
else puts "Usage: #{$0} --check | --sync"
end
