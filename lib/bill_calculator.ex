defmodule BillCalculator do

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
    Logger.info("[BillCalculator] GenServer BillCalculator initialized")
    {:ok, []}
  end

  def calc(bill_lines, seller, purchaser) do
    {:ok, GenServer.cast(__MODULE__, {:calc, bill_lines, seller, purchaser})}
  end

  @impl true
  def handle_cast({:calc, bill_lines, seller, purchaser}, data) do
    Logger.info("[BillCalculator] Piped to LaTeXFormatter filter")
    bill = calculate_bill(bill_lines)
    LaTeXFormatter.format(bill, seller, purchaser)
    {:noreply, [[bill: bill, seller: seller, purchaser: purchaser] | data]}
  end

  defp calculate_bill([]), do: []

  defp calculate_bill(bill_lines), do: do_calculate_bill([], bill_lines, 0)

  defp do_calculate_bill(acc, [], total), do: {acc, total}

  defp do_calculate_bill(acc, [pair = {product, qty} | t], total) do
    do_calculate_bill([{pair, product.price * qty} | acc], t, total + product.price * qty)
  end

end
