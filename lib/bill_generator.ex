defmodule BillGenerator do

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
    Logger.info("[BillGenerator] GenServer BillGenerator initialized")
    {:ok, []}
  end

  def generate(bill_lines, seller, purchaser) do
    {:ok, GenServer.cast(__MODULE__, {:generate, bill_lines, seller, purchaser})}
  end

  @impl true
  def handle_cast({:generate, bill_lines, seller, purchaser}, data) do
    Logger.info("[BillGenerator] Piped to BillCalculator filter")
    BillCalculator.calc(bill_lines, seller, purchaser)
    {:noreply, [[bill_lines: bill_lines, seller: seller, purchaser: purchaser] | data]}
  end

end
