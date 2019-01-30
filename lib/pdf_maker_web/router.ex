defmodule PdfMakerWeb.Router do
  use PdfMakerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

#   Other scopes may use custom stacks.
   scope "/api", PdfMakerWeb do
    pipe_through :api
    scope "/v1" do
      post "/html", HtmlToPdfController, :create
    end
   end

  scope "/options", PdfMakerWeb do
    get "/ping", OptionsController, :ping
    get "/fail", OptionsController, :fail
    get "/deploy_status", OptionsController, :deploy_status
    get "/full_stack_status", OptionsController, :full_stack_status
  end
end
