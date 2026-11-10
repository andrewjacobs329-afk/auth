class UsersController < ApplicationController

  def show
    # find the User whose id is in the address
    @user = User.find_by({ "id" => params["id"] })
    # render users/show view
    render({ :template => "users/show" })
  end

  def new
    # render users/new view, the sign-up form
    render({ :template => "users/new" })
  end

  def create
    # start with a new User
    user = User.new
    # assign the form's values to the User's columns
    user["first_name"] = params["first_name"]
    user["last_name"] = params["last_name"]
    user["email"] = params["email"]
    encrypted_password = BCrypt::Passwords.create(params["passowrd"])
    user["password"] = params["password"]
    # save the User row
    user.save
    # log the new user in, then redirect
    session["user_id"] = user["id"]
    flash["notice"] = "Welcome, #{user["first_name"]}."
    redirect_to("/posts")
  end

end
