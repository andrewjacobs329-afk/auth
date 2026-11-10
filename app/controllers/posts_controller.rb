class PostsController < ApplicationController

  def index
    # find all Post rows
    @posts = Post.all
    # render posts/index view
    render({ :template => "posts/index" })
  end

  def new
    # render posts/new view, the form for a new Post
    render({ :template => "posts/new" })
  end

  def create
    # start with a new Post
    post = Post.new
    # assign the form's values to the Post's columns
    post["author"] = params["author"]
    post["body"] = params["body"]
    post["image"] = params["image"]
    # save the Post row
    post.save
    # redirect the user
    redirect_to("/posts")
  end

  def destroy
    # find the Post
    post = Post.find_by({ "id" => params["id"] })
    # destroy the Post row if it belongs to the logged-in user
    if @current_user != nil && post != nil && post["user_id"] == @current_user["id"]
      post.destroy
    end
    # redirect the user
    redirect_to("/posts")
  end

end
