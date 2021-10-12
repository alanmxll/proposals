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

  describe "valid?/1" do
    test "warranty should be from a valid province" do
      valid_warranty = Core.Warranty.new(@fields)
      invalid_warranty_SC = Core.Warranty.new(%{@fields | province: "SC"})
      invalid_warranty_PR = Core.Warranty.new(%{@fields | province: "PR"})
      invalid_warranty_RS = Core.Warranty.new(%{@fields | province: "RS"})

      assert Core.Warranty.valid?(valid_warranty) == true
      refute Core.Warranty.valid?(invalid_warranty_SC) == true
      refute Core.Warranty.valid?(invalid_warranty_PR) == true
      refute Core.Warranty.valid?(invalid_warranty_RS) == true
    end
  end
end
