defmodule Core.Proponent do
  defstruct [:id, :name, :age, :monthly_income, main: false]

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def valid?(proponent) do
    proponent.age >= 18
  end
end
