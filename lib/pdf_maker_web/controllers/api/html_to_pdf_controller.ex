defmodule PdfMakerWeb.HtmlToPdfController do
  @moduledoc false
  use PdfMakerWeb, :controller

  action_fallback(PdfMakerWeb.FallbackController)

  require Logger

  def create(conn, %{"html" => html}) do
    with content = PdfMaker.MakePdf.make_pdf(html) do
      conn
      |> put_resp_content_type("application/pdf", nil)
      |> put_resp_header("content-disposition", ~s[attachment; filename="receipt.pdf"])
      |> send_resp(:created, content)
    end
  end
end
