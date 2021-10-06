defmodule Core.ValidatorTest do
  use ExUnit.Case, async: false

  alias Core.Validator

  describe "new/1" do
    test "should create a validator" do
      data = ""

      expected_validator = %Validator{data: ""}

      assert Validator.new(data) == expected_validator
    end
  end

  describe "validate/2" do
    test "should execute the validation function and return the validator" do
      data = 10
      is_bigger_then_10 = fn data -> data > 10 end
      is_even = fn data -> rem(data, 2) == 0 end

      validator = %Validator{data: data}
      invalid_validator = %Validator{data: data, is_valid: false}

      assert Validator.validate(validator, is_bigger_then_10) == invalid_validator
      assert Validator.validate(invalid_validator, is_even) == invalid_validator
    end
  end
end
