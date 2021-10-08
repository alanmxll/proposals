defmodule Core.ProponentTest do
  use ExUnit.Case, async: false

  alias Core.Proponent

  @fields %{id: 1, name: "Alan", age: 28, monthly_income: 4_000, main: true}

  def base_proponent(params \\ %{}) do
    new_params =
      params
      |> Enum.into(@fields)

    Map.merge(%Proponent{}, new_params)
  end

  describe "new/1" do
    test "should create a new proponent" do
      assert base_proponent() == Proponent.new(@fields)
    end
  end
end
