# Code style

Where this repo departs from Rails defaults, so that a reader who knows one resource knows them
all. Everything not listed here is plain Rails.

- Routes: one `resources("companies")` line per resource, with parentheses. Never write the
  seven actions' routes by hand. `bin/rails routes` lists every route.
- Every action that renders calls `render({ :template => "companies/index" })` explicitly, as
  its last step. Actions that redirect call `redirect_to("/companies")` and have no view.
- Read values from the address and from forms through `params`, with string keys:
  `params["id"]`, `params["name"]`. Everything in `params` arrives as a string.
- Forms are plain HTML: `<form action="/companies" method="post">`, one `<input>` per column
  with a `name` matching the column, and a `<button>`. Use `method="post"` for create. For
  update and destroy, add `<input type="hidden" name="_method" value="patch">` (or `delete`)
  inside a `post` form. No form helpers (`form_with`, `form_for`), no `link_to`.
- Hand values from an action to its view with instance variables (`@company`), and nothing
  else. A variable no view needs has no `@`.
- Read and set columns hash-style: `company["name"]` and `company["name"] = "Apple"`, not
  `company.name`. One exception: a model with `has_secure_password` takes the password as
  `user.password = params["password"]`, because that is a method, not a column; it hashes the
  value on its way into `password_digest`. `user.authenticate(guess)` checks a guess the same way.
- No `has_many`, `belongs_to` or other associations. Look related rows up with `where` or
  `find_by`, with a string-key hash: `Contact.where({ "company_id" => company["id"] })`.
- Keep code comments; ask before removing any. Some controllers sketch unwritten actions as
  commented steps. Leave those alone unless asked to build that action; then put the code under
  its steps, in order, with the comments still there.
- Tests create the rows they need inside the test. No fixtures (`test/fixtures/*.yml`).
- Change the database's structure only with a migration: `bin/rails generate model` or
  `bin/rails generate migration`, then `bin/rails db:migrate`. Never edit `db/schema.rb`;
  Rails writes it. The rows come from `scripts/create_data.rb`
  (`bin/rails runner scripts/create_data.rb`).
