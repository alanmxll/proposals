defmodule Core.Warranty do
  defstruct [:id, :value, :province]

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
