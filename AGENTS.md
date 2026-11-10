# AGENTS.md

Instructions for an AI agent working in this repo: a Rails app for learning how web apps are built, and how they tell their users apart.

## Rules

- Follow the code rules described in @docs/code-style.md. The rules may differ from Rails defaults, but always take priority.

- Follow common Rails conventions (e.g. REST) as long as they do not conflict with the specific code-style rules.

- Explain what you changed in plain English, file by file.

- Do not read, reference, or modify:
  - `agent-log/` (the record of this conversation, kept for graders)
  - `code-along-complete/` (a learning reference only)
  - `app/controllers/data_controller.rb`, `app/models/database_table.rb`, `app/views/data/` (for data visibility only)

## Commands

- `bin/rails server` runs the app
- `bin/rails test` runs the tests
- `bin/rails runner <path>` runs a ruby file
- `bin/reset-db` deletes every row; always ask before running

## New work

- When asked to build new behavior, check if a "Definition of done" list has been provided. If it hasn't, ask for it.
- Write one integration test per sentence or item in the "done" list, named with the sentence word for word, in `test/integration/<resource>_page_test.rb`.
- A sentence that says something must not happen gets a test too: one that does the forbidden thing and proves it was refused.
- Logging in inside a test: `post("/login", :params => { "email" => ..., "password" => ... })` after creating the user, the way `app/controllers/sessions_controller.rb` expects it.
- Never modify the "done" list without permission. If a sentence/item is unclear or can't be tested, say so instead.
