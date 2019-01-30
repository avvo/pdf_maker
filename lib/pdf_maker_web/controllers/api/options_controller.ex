defmodule PdfMakerWeb.OptionsController do
  use Phoenix.Controller, log: false

  def ping(conn, _) do
    conn |> text("PONG")
  end

  def fail(conn, _) do
    msg = "Error intentionally raised from /options/fail"
    conn |> send_resp(:internal_server_error, msg)
  end

  def deploy_status(conn, _) do
    errs = errors_local() ++ errors_remote()
    errs |> send_errs(conn)
  end

  def full_stack_status(conn, _) do
    errors_local()
    |> send_errs(conn)
  end

  def errors_local(_ \\ nil) do
    app_modules() |> alive_errs
  end

  def errors_remote(_ \\ nil) do
    []
  end

  def app_modules do
    [
      PdfMakerWeb.Supervisor
    ]
  end

  defp cache_status(errs, {:ok, [true]}) do
    errs
  end
  defp cache_status(errs, _) do
    ["cache not loaded" | errs]
  end

  defp send_errs([], conn), do: conn |> text("OK")

  defp send_errs(errs, conn) do
    msg = Enum.join(errs, "\n")
    conn |> send_resp(:internal_server_error, msg)
  end

  defp alive_errs(modules), do: modules |> Enum.reduce([], &alive_err/2)

  defp alive_err(module, acc) do
    case application_alive?(module) do
      true -> acc
      false -> ["#{module} is down" | acc]
    end
  end

  def application_alive?(module) do
    case Process.whereis(module) do
      nil -> false
      pid -> Process.alive?(pid)
    end
  end
end
