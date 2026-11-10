# Finished code-alongs

Each folder is one code-along as it ended in class. The files inside sit at the same paths
they have in the app, so you can open yours and the finished one side by side, or copy a file
over yours to catch up. The folders build on each other: `2-at-rest/` assumes `1-login/` is
in place, and `3-access/` assumes both.

| Folder | What it finishes |
|---|---|
| `1-login/` | `sessions#create`: find the user by email, compare the password, put the id in the session. Passwords are still plain text in the table. |
| `2-at-rest/` | `has_secure_password` on `User`; `users#create` hands the password to the model, which hashes it; `sessions#create` checks a guess with `authenticate`. The two users that were there before keep their plain-text passwords and can no longer log in. |
| `3-access/` | `users#show` turns away anyone who is not the user in the address. Before this, `/users/2` showed any user's email to anyone. |

The posts lab (the four tickets) is not here: it is yours, through your pull request. The
written solution is linked from Canvas after class.
