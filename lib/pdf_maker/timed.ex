defmodule PdfMaker.Timing do
  @moduledoc false

  defmodule TimingRecord do
    @type detail_t :: %{
                        metric_group: String.t(),
                        started_at: integer,
                        ended_at: integer,
                        duration: integer
                      }

    @type t :: %__MODULE__{
      timing: detail_t
    }

    @derive Jason.Encoder
    defstruct [
      timing: [
        metric_group: "",
        started_at: 0,
        ended_at: 0,
        duration: 0
      ]
    ]

    def new(metric_group, started_at, ended_at, duration) do
      %__MODULE__{timing: %{metric_group: metric_group, started_at: started_at, ended_at: ended_at, duration: duration}}
    end
  end

  defimpl String.Chars, for: TimingRecord do
    def to_string(%TimingRecord{} = record) do
      Jason.encode!(record)
    end
  end

  defmacro __using__(_) do
    quote do
      import PdfMaker.Timing
    end
  end

  defmacro metric_group(nil) do
    quote do
      {function_name, arity} = __ENV__.function
      "#{__ENV__.module}.#{function_name}/#{arity}" # standard Elixir function notation
    end
  end

  defmacro metric_group(metric_name) do
    quote(do: unquote(metric_name))
  end

  defmacro timed(metric_name \\ nil, [do: block]) do
    quote do
      started_at = :os.system_time(:millisecond)
      result = unquote(block)
      ended_at = :os.system_time(:millisecond)
      diff = ended_at - started_at
      Logger.info(TimingRecord.new(metric_group(unquote(metric_name)), started_at, ended_at, diff))
#      Logger.info("#{__MODULE__} STATS_DOGGO: #{metric_group(unquote(metric_name))}, duration: #{diff}")
      result
    end
  end
end
