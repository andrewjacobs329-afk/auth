# Delete my own post
As a signed-in user, I want to delete a post I made, so a taco I regret posting is gone from the feed.

## Definition of done

- On the feed, each post that belongs to the logged-in user has a Delete button.
- Pressing it deletes that post and sends the user back to the feed, where the post is gone.
- The button sends a DELETE request to /posts/:id, following the pattern used for companies.

## Notes

- `destroy` goes in `app/controllers/posts_controller.rb`; `resources("posts")` already routes to it.
