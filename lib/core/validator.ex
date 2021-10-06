defmodule Core.Validator do
  defstruct [:data, is_valid: true]

  def new(data) do
    %Core.Validator{data: data}
  end

  def validate(%Core.Validator{is_valid: true} = validator, func) do
    is_valid = func.(validator.data)
    %Core.Validator{data: validator.data, is_valid: is_valid}
  end

  def validate(validator, _func), do: validator
end
