# 2. Passwords at rest

Three files change, and the plain `password` column stops being written.

- `app/models/user.rb`: `has_secure_password`. The model now has a `password=` method that
  hashes what it is given (bcrypt, with a fresh salt each time, as `scripts/encryption.rb`
  shows) and stores the hash in `password_digest`, and an `authenticate(guess)` method that
  hashes a guess the same way and compares.
- `app/controllers/users_controller.rb`: `user.password = params["password"]` in place of
  `user["password"] = ...`. The hash-style write would put plain text in the column again; the
  method is the one way in. This is the one exception listed in `docs/code-style.md`.
- `app/controllers/sessions_controller.rb`: `user.authenticate(params["password"])` in place
  of the `==`.

Sign up again and look at `/data`: the new row has a `password_digest` and no `password`. Then
try to log in as Ben or Brian, the two users who were already in the table: "Nope." Their
`password_digest` is empty, because nobody ever hashed their passwords, and the plain text they
still have is not consulted any more. That is tech debt with a date on it: every user from
before the change is locked out until someone writes the migration that moves them over, and
no migration can hash a password it does not have. Real systems do it on the next login.
