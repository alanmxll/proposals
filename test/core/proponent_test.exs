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

  describe "valid?/1" do
    test "proponent if it is older than or equal to 18" do
      valid_proponent = base_proponent()
      less_than_18_proponent = base_proponent(%{age: 17})

      assert Proponent.valid?(valid_proponent) == true
      refute Proponent.valid?(less_than_18_proponent) == true
    end
  end
end
