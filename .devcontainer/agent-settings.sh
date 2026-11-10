#!/bin/bash
# Agent settings that can only live in the home folder. The rest are in the
# repo: .claude/settings.json, .codex/ and .gemini/settings.json.
#
# Runs from the top folder of the repo, once, when the Codespace is created.
set -e

workspace="$(pwd)"

# Codex reads this repo's .codex/ folder (its rules and config) only in a
# project marked trusted. The path comes from the Codespace, since a copy of
# this repo can have any name.
mkdir -p ~/.codex
touch ~/.codex/config.toml
if ! grep -qF "[projects.\"$workspace\"]" ~/.codex/config.toml; then
  cat >> ~/.codex/config.toml <<EOF

[projects."$workspace"]
trust_level = "trusted"
EOF
fi

# At the end of each turn, Codex runs bin/save-log, which copies the session
# into agent-log/. notify is read only from the home folder, and only as a
# top-level key, so it goes at the top of the file.
if ! grep -q '^notify' ~/.codex/config.toml; then
  { echo "notify = [\"$workspace/bin/save-log\", \"--quiet\"]"; cat ~/.codex/config.toml; } > ~/.codex/config.toml.new
  mv ~/.codex/config.toml.new ~/.codex/config.toml
elif ! grep -q '^notify.*bin/save-log' ~/.codex/config.toml; then
  echo "Note: ~/.codex/config.toml already has a notify line, so Codex won't run bin/save-log after each turn. Run bin/save-log before each commit." >&2
fi

# Antigravity CLI reads permissions only from the home folder. Routine
# commands run without asking; bin/reset-db always asks; agent-log/ (the
# record of each conversation, for graders) is off limits.
mkdir -p ~/.gemini/antigravity-cli
cat > ~/.gemini/antigravity-cli/settings.json <<'EOF'
{
  "permissions": {
    "allow": [
      "command(bin/rails test)",
      "command(bin/rails runner)",
      "command(bin/rails db:migrate)",
      "command(bin/rails generate model)",
      "command(bin/rails generate migration)",
      "command(bin/rails generate controller)",
      "command(bin/rails routes)",
      "command(gh issue view)",
      "command(gh issue list)",
      "command(git status)",
      "command(git diff)",
      "command(git log)"
    ],
    "ask": [
      "command(bin/reset-db)"
    ],
    "deny": [
      "read_file(agent-log/)",
      "command(regex:.*agent-log.*)"
    ]
  }
}
EOF

# Gemini CLI ignores policy files kept in a repo, so its rule for agent-log/
# lives in the home folder too.
mkdir -p ~/.gemini/policies
cat > ~/.gemini/policies/agent-log.toml <<'EOF'
[[rule]]
toolName = "run_shell_command"
commandRegex = ".*agent-log.*"
decision = "deny"
priority = 900
denyMessage = "agent-log/ is the record of this conversation, kept for graders. Leave it alone."

[[rule]]
toolName = ["read_file", "read_many_files", "write_file", "replace"]
argsPattern = "agent-log"
decision = "deny"
priority = 900
denyMessage = "agent-log/ is the record of this conversation, kept for graders. Leave it alone."
EOF
