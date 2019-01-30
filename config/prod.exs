use Mix.Config

config :pdf_maker, PdfMakerWeb.Endpoint,
  http: [port: System.get_env("PORT") || 4000],
  secret_key_base: System.get_env("PDF_MAKER_KEY_BASE")

config :pdf_generator,
       wkhtml_path: "/usr/bin/wkhtmltopdf"

config :phoenix, :serve_endpoints, true

config :logger, level: :info
