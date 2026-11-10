require "test_helper"

class PostsPageTest < ActionDispatch::IntegrationTest
  # Ticket 1 (Issue #6): Only members can post
  test "The feed at /posts still shows every post to a visitor who is not logged in." do
    post1 = Post.new
    post1["body"] = "Delicious tacos"
    post1["image"] = "https://example.com/taco1.jpg"
    post1.save

    post2 = Post.new
    post2["body"] = "Amazing salsa"
    post2["image"] = "https://example.com/salsa.jpg"
    post2.save

    get("/posts")
    assert_response :success
    assert_select "p", { :text => post1["body"] }
    assert_select "p", { :text => post2["body"] }
  end

  test "A visitor who is not logged in and opens the new post page is sent to the login page instead." do
    get("/posts/new")
    assert_redirected_to("/login")
  end

  test "A visitor who is not logged in and submits the form does not create a post, and is sent to the login page." do
    initial_count = Post.all.count

    post("/posts", :params => {
      "body" => "Unauthorized post",
      "image" => "https://example.com/unauth.jpg"
    })

    assert_redirected_to("/login")
    assert_equal initial_count, Post.all.count
  end

  # Ticket 2 (Issue #7): Posts carry their author
  test "The new post form has fields for the body and the image, and no field for the author." do
    user = User.new
    user["first_name"] = "Alice"
    user["last_name"] = "Smith"
    user["email"] = "alice@example.com"
    user["password"] = "password"
    user.save

    post("/login", :params => { "email" => user["email"], "password" => user["password"] })

    get("/posts/new")
    assert_response :success
    assert_select "form[action='/posts']" do
      assert_select "input[name='body']"
      assert_select "input[name='image']"
      assert_select "input[name='author']", 0
    end
  end

  test "Submitting the form creates a post whose user_id is the id of the logged-in user, taken from the session and never from the form." do
    user_a = User.new
    user_a["first_name"] = "Alice"
    user_a["last_name"] = "Smith"
    user_a["email"] = "alice@example.com"
    user_a["password"] = "password"
    user_a.save

    user_b = User.new
    user_b["first_name"] = "Bob"
    user_b["last_name"] = "Jones"
    user_b["email"] = "bob@example.com"
    user_b["password"] = "password"
    user_b.save

    post("/login", :params => { "email" => user_a["email"], "password" => user_a["password"] })

    post("/posts", :params => {
      "body" => "Alice taco post",
      "image" => "https://example.com/alice.jpg",
      "author" => "Bob",
      "user_id" => user_b["id"]
    })

    assert_redirected_to("/posts")
    created_post = Post.find_by({ "body" => "Alice taco post" })
    assert_not_nil created_post
    assert_equal user_a["id"], created_post["user_id"]
  end

  test "On the feed, a post shows the first name of the user it belongs to." do
    user = User.new
    user["first_name"] = "Alice"
    user["last_name"] = "Smith"
    user["email"] = "alice@example.com"
    user["password"] = "password"
    user.save

    post = Post.new
    post["body"] = "Alice's taco"
    post["image"] = "https://example.com/alice.jpg"
    post["user_id"] = user["id"]
    post.save

    get("/posts")
    assert_response :success
    assert_select "h3", { :text => user["first_name"] }
  end

  # Ticket 3 (Issue #8): Delete my own post
  test "On the feed, each post that belongs to the logged-in user has a Delete button." do
    user = User.new
    user["first_name"] = "Alice"
    user["last_name"] = "Smith"
    user["email"] = "alice@example.com"
    user["password"] = "password"
    user.save

    post = Post.new
    post["body"] = "Alice's taco"
    post["image"] = "https://example.com/alice.jpg"
    post["user_id"] = user["id"]
    post.save

    post("/login", :params => { "email" => user["email"], "password" => user["password"] })

    get("/posts")
    assert_response :success
    assert_select "form[action='/posts/#{post["id"]}'] button", { :text => "Delete" }
  end

  test "Pressing it deletes that post and sends the user back to the feed, where the post is gone." do
    user = User.new
    user["first_name"] = "Alice"
    user["last_name"] = "Smith"
    user["email"] = "alice@example.com"
    user["password"] = "password"
    user.save

    post = Post.new
    post["body"] = "Alice's taco"
    post["image"] = "https://example.com/alice.jpg"
    post["user_id"] = user["id"]
    post.save

    post("/login", :params => { "email" => user["email"], "password" => user["password"] })

    delete("/posts/#{post["id"]}")
    assert_redirected_to("/posts")
    get("/posts")
    assert_response :success
    assert_nil Post.find_by({ "id" => post["id"] })
    assert_select "p", { :count => 0, :text => post["body"] }
  end

  test "The button sends a DELETE request to /posts/:id, following the pattern used for companies." do
    user = User.new
    user["first_name"] = "Alice"
    user["last_name"] = "Smith"
    user["email"] = "alice@example.com"
    user["password"] = "password"
    user.save

    post = Post.new
    post["body"] = "Alice's taco"
    post["image"] = "https://example.com/alice.jpg"
    post["user_id"] = user["id"]
    post.save

    post("/login", :params => { "email" => user["email"], "password" => user["password"] })

    get("/posts")
    assert_response :success
    assert_select "form[action='/posts/#{post["id"]}'][method='post']" do
      assert_select "input[type='hidden'][name='_method'][value='delete']"
      assert_select "button", { :text => "Delete" }
    end
  end

  # Ticket 4 (Issue #9): Nobody deletes your post
  test "Signed in as a different user, the feed shows no Delete button on a post that is not mine." do
    user_a = User.new
    user_a["first_name"] = "Alice"
    user_a["last_name"] = "Smith"
    user_a["email"] = "alice@example.com"
    user_a["password"] = "password"
    user_a.save

    user_b = User.new
    user_b["first_name"] = "Bob"
    user_b["last_name"] = "Jones"
    user_b["email"] = "bob@example.com"
    user_b["password"] = "password"
    user_b.save

    post_a = Post.new
    post_a["body"] = "Alice's taco"
    post_a["image"] = "https://example.com/alice.jpg"
    post_a["user_id"] = user_a["id"]
    post_a.save

    post_b = Post.new
    post_b["body"] = "Bob's taco"
    post_b["image"] = "https://example.com/bob.jpg"
    post_b["user_id"] = user_b["id"]
    post_b.save

    post("/login", :params => { "email" => user_b["email"], "password" => user_b["password"] })

    get("/posts")
    assert_response :success

    assert_select "form[action='/posts/#{post_a["id"]}']", 0
    assert_select "form[action='/posts/#{post_b["id"]}'] button", { :text => "Delete" }
  end

  test "Signed in as a different user, a DELETE request to /posts/:id for a post that is not mine is refused: the post is still there afterwards." do
    user_a = User.new
    user_a["first_name"] = "Alice"
    user_a["last_name"] = "Smith"
    user_a["email"] = "alice@example.com"
    user_a["password"] = "password"
    user_a.save

    user_b = User.new
    user_b["first_name"] = "Bob"
    user_b["last_name"] = "Jones"
    user_b["email"] = "bob@example.com"
    user_b["password"] = "password"
    user_b.save

    post = Post.new
    post["body"] = "Alice's taco"
    post["image"] = "https://example.com/alice.jpg"
    post["user_id"] = user_a["id"]
    post.save

    post("/login", :params => { "email" => user_b["email"], "password" => user_b["password"] })

    delete("/posts/#{post["id"]}")
    assert_redirected_to("/posts")
    assert_not_nil Post.find_by({ "id" => post["id"] })
  end

  test "Not signed in at all, a DELETE request to /posts/:id is refused the same way." do
    user = User.new
    user["first_name"] = "Alice"
    user["last_name"] = "Smith"
    user["email"] = "alice@example.com"
    user["password"] = "password"
    user.save

    post = Post.new
    post["body"] = "Alice's taco"
    post["image"] = "https://example.com/alice.jpg"
    post["user_id"] = user["id"]
    post.save

    delete("/posts/#{post["id"]}")
    assert_redirected_to("/posts")
    assert_not_nil Post.find_by({ "id" => post["id"] })
  end
end
