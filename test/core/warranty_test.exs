defmodule Core.WarrantyTest do
  use ExUnit.Case, async: false

  alias Core.Warranty

  @fields %{id: 1, value: 90_000, province: "CE"}

  describe "new/1" do
    test "should creates a warranty if all fields are ok" do
      warranty = %Core.Warranty{id: 1, value: 90_000, province: "CE"}

      assert warranty == Core.Warranty.new(@fields)
    end
  end
end
