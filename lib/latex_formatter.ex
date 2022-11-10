defmodule LaTeXFormatter do

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
    Logger.info("LaTeXFormatter] GenServer LaTeXFormatter initialized")
    {:ok, []}
  end

  def format(bill, seller, purchaser) do
    {:ok, GenServer.cast(__MODULE__, {:format, bill, seller, purchaser})}
  end

  @impl true
  def handle_cast({:format, bill, seller, purchaser}, data) do
    latex = generate_latex(bill, seller, purchaser)
    Logger.info("[LaTeXFormatter] Piped to LaTeXToPdf filter")
    LaTeXToPdf.generate(latex)
    {:noreply, [latex | data]}
  end

  def generate_latex(bill, seller, purchaser) do
    "\\documentclass[a4paper, 10pt]{letter}\n\\address{#{String.replace(seller, ",", ", \\\\ \n")}}\n\\begin{document}\n\\begin{letter}\n{#{String.replace(purchaser, ",", ", \\\\ \n")}}\n\\opening{}\n\\begin{center}\n\\begin{tabular}{| p{7cm} | l | l | l |}\n\\hline\nDescription & Quantity & Price & Amount \\\\ \\hline \n" <> format_bill(bill) <> "\\end{tabular}\n\\end{center}\n\\closing{Seal or signature:}\n\\end{letter}\n\\end{document}"
  end

  defp format_bill([]), do: ""
  defp format_bill({bill_lines, total}) do
    do_format_bill("", Enum.reverse(bill_lines), total)
  end

  defp do_format_bill(acc, [], total) do
    acc <> "\\multicolumn{3}{|c|}{TOTAL} & #{:erlang.float_to_binary(total, [decimals: 2])} \\\\ \\hline\n"
  end

  defp do_format_bill(acc, [{{product, qty}, amount} | t], total) do
    do_format_bill(acc <> "#{product.name} & #{qty} & #{:erlang.float_to_binary(product.price, [decimals: 2])} & #{:erlang.float_to_binary(amount, [decimals: 2])} \\\\ \\hline \n", t, total)
  end

end
