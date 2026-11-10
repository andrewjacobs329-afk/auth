# Posts carry their author
As a signed-in user, my posts show my name, so nobody has to type a name and nobody can type someone else's.

## Definition of done

- The new post form has fields for the body and the image, and no field for the author.
- Submitting the form creates a post whose user_id is the id of the logged-in user, taken from the session and never from the form.
- On the feed, a post shows the first name of the user it belongs to.

## Notes

- The `posts` table has a `user_id` column, added by a migration that has already run. The two posts that were there before it have no `user_id` and still have their `author`.
- Look the user up with `User.find_by({ "id" => post["user_id"] })`.
