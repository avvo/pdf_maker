defmodule PdfMakerWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PdfMakerWeb, :controller

#  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
#    conn
#    |> put_status(:unprocessable_entity)
#    |> render(ScooterWeb.ChangesetView, "error.json", changeset: changeset)
#  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(PdfMakerWeb.ErrorView, :"404")
  end

  def call(conn, {:error, message}) when is_binary(message) do
    conn
    |> put_status(:unprocessable_entity)
    |> assign(:message, message)
    |> render(PdfMakerWeb.ErrorView, :"422") # => json {"error" : "message"}
  end
end
