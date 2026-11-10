require "test_helper"

class PostsPageTest < ActionDispatch::IntegrationTest
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
