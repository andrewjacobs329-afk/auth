class SessionsController < ApplicationController

  def new
    # render sessions/new view, the login form
    render({ :template => "sessions/new" })
  end

  def create
    # 1. find the User whose email was typed in the form
    user = User.find_by({ "email" => params["email"] })
    # 2. check the password
    if user && user.authenticate(params["password"])
      # 3. if both hold, put the user's id in the session, then redirect to the posts
      session["user_id"] = user["id"]
      flash["notice"] = "Welcome back, #{user["first_name"]}."
      redirect_to("/posts")
    else
      # 4. otherwise redirect back to the login form
      flash["notice"] = "Nope."
      redirect_to("/login")
    end
  end

  def destroy
    # empty the session, then redirect
    session["user_id"] = nil
    flash["notice"] = "Goodbye."
    redirect_to("/posts")
  end

end
