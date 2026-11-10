class ApplicationController < ActionController::Base
  # Runs before every action in every controller.
  before_action :find_current_user

  def find_current_user
    # the session is a small, signed box that travels with the browser as a cookie;
    # logging in puts the user's id in it, logging out empties it
    @current_user = User.find_by({ "id" => session["user_id"] })
  end
end
