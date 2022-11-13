defmodule Product do
  defstruct [:name, :price]
  @typedoc """
  Struct que representa un producto na factura.
  """
  @type t :: %__MODULE__{
    name: nil | String.t,
    price: float()
}
end
