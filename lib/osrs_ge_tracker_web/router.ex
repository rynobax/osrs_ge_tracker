defmodule OsrsGeTrackerWeb.Router do
  use OsrsGeTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OsrsGeTrackerWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/about", AboutController, :index
    get "/item/:name", ItemController, :index
  end
end
