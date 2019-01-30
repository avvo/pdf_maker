defmodule PdfMakerWeb.ErrorView do
  use PdfMakerWeb, :view

  def render("400.json", %{message: message}) do
    %{error: message}
  end

  def render("422.json", %{message: message}) do
    %{error: message}
  end

  def render("404.json", _assigns) do
    %{
      errors: [
        %{
          status: 404,
          title: "Not Found",
          detail: "Not Found"
        }
      ]
    }
  end

  def render("500.json", _assigns) do
    %{
      errors: [
        %{
          status: 500,
          title: "Internal server error",
          detail: "Something bad happened"
        }
      ]
    }
  end

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
