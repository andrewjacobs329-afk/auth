# Only members can post
As an anonymous visitor, I can read the feed but not post to it, so Tacostagram stays a place where every post has a person behind it.

## Definition of done

- The feed at /posts still shows every post to a visitor who is not logged in.
- A visitor who is not logged in and opens the new post page is sent to the login page instead.
- A visitor who is not logged in and submits the form does not create a post, and is sent to the login page.

## Notes

- `@current_user` is set before every action (see `app/controllers/application_controller.rb`); it is `nil` when nobody is logged in.
- The login page is `/login`.
