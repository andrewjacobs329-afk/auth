# 3. Who may see this page

`users#show` gets its missing rule. Before: `/users/1` is your account page, and changing the
address to `/users/2` showed someone else's email, because nothing in the action asked who was
looking. That is broken access control, the most common serious flaw in web apps (OWASP Top
10, number one).

After: the action compares the user in the address with the logged-in user, and turns the
request away when they differ, when nobody is logged in (`@current_user` is `nil` then), or
when there is no such user. The `return` matters: without it, Rails would try to redirect and
render in the same request.

The rule lives in the controller, not in the page. Hiding a link is not a rule; a request can
be typed into the address bar.
