defmodule PdfMaker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      PdfMakerWeb.Endpoint,
      make_pdf_spec()
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PdfMaker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def make_pdf_spec() do
    %{
      id: MakePdf,
      start: {
        PdfMaker.MakePdf, :start_link, []
      }
    }
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PdfMakerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
