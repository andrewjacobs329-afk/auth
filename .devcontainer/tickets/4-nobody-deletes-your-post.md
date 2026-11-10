# Nobody deletes your post
As another user, I want to delete your post. This must fail: a post can only be deleted by the user it belongs to.

## Definition of done

- Signed in as a different user, the feed shows no Delete button on a post that is not mine.
- Signed in as a different user, a DELETE request to /posts/:id for a post that is not mine is refused: the post is still there afterwards.
- Not signed in at all, a DELETE request to /posts/:id is refused the same way.

## Notes

- This is the abuse story for ticket 3. A button that is hidden is not a rule; the rule lives in the controller, where every request arrives.
- "Refused" means the action does not delete, and redirects (to the feed or to the login page).
