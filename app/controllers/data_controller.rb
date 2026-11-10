class DataController < ApplicationController
  # Every table in the database and its rows, read-only. Reading them is kept out of
  # log/development.log, so the bottom of the log stays the SQL your own pages ran.
  def show
    ActiveRecord::Base.logger.silence do
      @tables = DatabaseTable.all
      render({ :template => "data/show", :layout => "data" })
    end
  end
end
