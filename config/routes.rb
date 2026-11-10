Rails.application.routes.draw do
  # get("/things", { :controller => "things", :action => "index" })

  get("/", { :controller => "home", :action => "index" })
  get("/data", { :controller => "data", :action => "show" })
  get("/tacos", { :controller => "tacos", :action => "index" })
  get("/dice", { :controller => "dice", :action => "index" })
  get("/bitcoins", { :controller => "bitcoins", :action => "index" })

  # One line, seven routes: index, show, new, create, edit, update, destroy.
  resources("companies")
  resources("contacts")
  resources("posts")
  resources("users")

  # Logging in and out break the pattern on purpose: there is no sessions table, and
  # /login reads better than /sessions/new. Three routes, written out.
  get("/login", { :controller => "sessions", :action => "new" })
  post("/login", { :controller => "sessions", :action => "create" })
  get("/logout", { :controller => "sessions", :action => "destroy" })
end
