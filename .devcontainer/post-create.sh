#!/bin/bash
set -e

# sqlite3 is the command-line client behind bin/rails dbconsole. The Ruby
# image already carries the library the app itself uses.
apt-get update -qq
apt-get install -y -qq sqlite3 > /dev/null

# AI coding agents. Claude Code comes from the devcontainer feature.
npm install -g --silent @openai/codex @google/gemini-cli

# Antigravity CLI installs itself into ~/.local/bin and adds that folder to the
# PATH in ~/.bashrc, which a terminal opened before this script finished never
# reads. Link it into /usr/local/bin, which every terminal already searches.
curl -fsSL https://antigravity.google/cli/install.sh | bash
test -x "$HOME/.local/bin/agy"
ln -sf "$HOME/.local/bin/agy" /usr/local/bin/agy

bundle install

# Creates the database and runs the migrations, then creates the rows.
bin/rails db:setup
bin/rails runner scripts/create_data.rb

# Settings the agents keep in the home folder rather than in this repo.
bash .devcontainer/agent-settings.sh

# The four tickets, as GitHub issues on this copy of the repo.
bin/ticket
