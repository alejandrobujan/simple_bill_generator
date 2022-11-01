defmodule LaTeXToPdf do

  use GenServer
  require Logger

  @spec start_link(list) :: {:ok, pid()}
  def start_link(_init_arg) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @spec stop() :: :ok
  def stop() do
    GenServer.stop(__MODULE__)
  end

  @impl true
  def init(_init_arg) do
    Logger.info("[LaTeXToPdf] GenServer LaTeXToPdf initialized")
    {:ok, []}
  end

  def generate(latex) do
    {:ok, GenServer.cast(__MODULE__, {:generate, latex})}
  end

  @impl true
  def handle_cast({:generate, latex}, data) do
    filename = generate_filename()
    if !File.exists?("tmp/"), do: File.mkdir("tmp/")
    Iona.source(latex) |> Iona.write!(filename)
    Logger.info("[LaTeXToPdf] PDF Created. Output file: #{filename}")
    {:noreply, [{filename, latex} | data]}
  end

  @spec generate_filename() :: String.t()
  defp generate_filename() do
    {{y, mon, d},{h, min, s}} = :calendar.local_time()
    "tmp/bill-#{y}-#{mon}-#{d}-#{h}-#{min}-#{s}.pdf"
  end

end
