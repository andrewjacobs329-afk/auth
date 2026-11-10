# 1. Logging in

`sessions#create`, written together. The four commented steps were already in the controller;
these are the lines under them.

A user who exists and typed the right password gets their `id` put in `session["user_id"]`.
The session is a signed cookie: the browser carries it back with every request, Rails checks
the signature, and `application_controller.rb` turns the id back into `@current_user` before
every action. Anyone else gets "Nope." and the form again.

At this step the comparison is `user["password"] == params["password"]`, plain text against
plain text, because that is what the `users` table holds. `2-at-rest/` changes that.
