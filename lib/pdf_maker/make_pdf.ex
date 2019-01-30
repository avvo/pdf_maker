defmodule PdfMaker.MakePdfBehaviour do
  @type html_t :: String.t()
  @callback make_pdf(html_t) :: list(binary)
end

defmodule PdfMaker.MakePdf do
  @moduledoc false

  use GenServer
  use StandardLogging

  @behaviour PdfMaker.MakePdfBehaviour

  require Logger

  ## ##########################################################################
  ## Public API

  def make_pdf(html) do
    timed() do
      GenServer.call(:pdf_maker,  {:make_pdf, %{html: html}})
    end
  end

  ## ##########################################################################
  ## GenServer

  def init(args) do
    {:ok, args}
  end

  def start_link() do
    Logger.info("#{__MODULE__}::start_link")
    GenServer.start_link(__MODULE__, [], name: :pdf_maker)
  end

  def handle_call({:make_pdf, %{html: html}}, _from, state) do
    pdf_content = convert_html_to_pdf(html)
    {:reply, pdf_content, state}
  end

  ## ##########################################################################
  ## Implementation

  defp options() do
    [
      page_size: "Letter",
      delete_temporary: true
    ]
  end

  defp convert_html_to_pdf(html) do
    case PdfGenerator.generate_binary(html, options()) do
      {:ok, pdf_content} ->
        info("Created PDF")
        pdf_content
      {:error, error} ->
        error("Error creating PDF: #{inspect(error)}")
        error
    end
  end
end
