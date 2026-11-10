# auth

Tacostagram, with accounts. A Rails app where visitors sign up, log in and log out, and where
the posts are about to belong to the people who made them. Companies and contacts from the
earlier weeks are still here, finished. Some of the account code is written for you to read,
one action is left as commented steps to fill in together, and four tickets are waiting.

## Getting started

1. On this repo's GitHub page, choose **Use this template**, then **Create a new repository**.
   Make the copy in your own account and choose **Private**.
2. On your copy, choose **Code**, then **Codespaces**, then **Create codespace on main**. The
   first start takes a few minutes: it installs the gems and the agent CLIs, creates the
   database with its rows, and opens four tickets in your repo's **Issues** tab.
3. In the terminal, start the app:

       bin/rails server

   Leave that terminal running; open a second one for everything else. When the Codespace
   offers to open port 3000 in the browser, take it (or find it later under **Ports**). The
   home page lists every page in the app; click **Tacostagram**.
4. Look at your repo's **Issues** tab on GitHub. Four tickets should be there. If the tab is
   empty, run `bin/ticket` in the second terminal and read what it says.

If the server isn't running, the browser shows "connection refused" or a 502. Start it again
with `bin/rails server`.

## The accounts

Two users are already in the table, with their passwords as typed:

| Email | Password |
|---|---|
| ben@example.com | tacos123 |
| brian@example.com | password |

`/data` shows them, and so does `bin/rails runner scripts/show_data.rb User`.

Logging in is three steps, and they are the commented steps in `sessions#create`
(`app/controllers/sessions_controller.rb`):

1. Find the user whose email was typed in the form.
2. Check the password.
3. If both hold, put the user's `id` in the session and redirect. Otherwise, back to the form.

The session is a small signed cookie. The browser sends it back with every request, and
`app/controllers/application_controller.rb` turns the id in it into `@current_user` before
every action, in every controller. The navbar in `app/views/layouts/application.html.erb`
reads `@current_user` to decide what to show. Logging out empties the session.

The rest is written and worth reading: sign-up (`users#new`, `users#create`), the account page
(`users#show`), logout (`sessions#destroy`). Logging in and out use three routes written out by
hand in `config/routes.rb` instead of a `resources` line, because there is no `sessions` table
and `/login` reads better than `/sessions/new`.

## The pattern, still

Posts, companies, contacts and users each get the same seven actions from one
`resources(...)` line. `bin/rails routes` prints every route the app has.

| Action | What it does | Method | Path | Has a view? |
|---|---|---|---|---|
| `index` | list every post | GET | `/posts` | yes |
| `show` | one post | GET | `/posts/7` | yes |
| `new` | the form for a new post | GET | `/posts/new` | yes |
| `create` | save the form, then redirect | POST | `/posts` | no |
| `edit` | the form for an existing post | GET | `/posts/7/edit` | yes |
| `update` | save the form, then redirect | PATCH | `/posts/7` | no |
| `destroy` | delete it, then redirect | DELETE | `/posts/7` | no |

## The tickets

Your repo's **Issues** tab has four tickets. Each has a story and, under "Definition of done",
three sentences that say when it's finished. `bin/ticket` made them from the files in
`.devcontainer/tickets/`; running it again is safe. The fourth ticket is written from the
other side: it describes something that must fail, and its tests prove that it does.

To build one, make a branch first: bottom-left corner of the Codespace, click `main`,
**Create new branch**, type a name, Enter. Then ask your agent to read the issue
(`gh issue view 1`) and build it, with one test per sentence. Try the page yourself and run
`bin/rails test`. Commit, **Publish Branch**, and open the pull request from the banner on your
repo's GitHub page, with the issue number in the body ("closes #1").

## Catching up

`code-along-complete/` has the finished files from each code-along, at the same paths they
have in the app. See its README.

## The data

`scripts/create_data.rb` creates the rows. Change it and run it again any time:

    bin/rails runner scripts/create_data.rb

It deletes the companies, contacts, posts and users first, so it always ends with exactly the
rows in the file. `bin/rails runner scripts/show_data.rb` prints every table in the terminal,
and `/data` shows them in the browser.

The tables:

- `users`: `first_name`, `last_name`, `email`, `password`, `password_digest`
- `posts`: `author`, `body`, `image`, `user_id`
- `companies`: `name`, `city`, `state`, `url`
- `contacts`: `first_name`, `last_name`, `email`, `phone_number`, `company_id`

`password_digest` is empty for the two users in the file, and `user_id` is empty for the two
posts. Both columns were added after those rows existed.

`scripts/encryption.rb` hashes one secret twice and checks guesses against the hashes.
`bin/rails runner scripts/encryption.rb` runs it.

## Working with an agent

`AGENTS.md` tells your agent how work happens here: tickets, one test per sentence, the
pattern, the commands, and that a sentence saying something must not happen gets a test too.
The code rules it points at are in `docs/code-style.md`. Signing in to an agent CLI is covered
in the `agent-setup` repo's README. Every conversation with your agent here is copied into
`agent-log/`; leave that folder alone.
