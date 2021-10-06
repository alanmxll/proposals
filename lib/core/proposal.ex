defmodule Core.Proposal do
  defstruct [:id, :loan_value, :number_of_monthly_installments]

  alias Core.Validator

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def valid?(proposal) do
    proposal
    |> to_validator()
    |> evaluate(&valid_loan_value?/1)
    |> evaluate(&valid_number_of_monthly_installments?/1)
    |> result()
  end

  defp to_validator(proposal) do
    Validator.new(proposal)
  end

  defp evaluate(validator, function) do
    Validator.validate(validator, function)
  end

  defp result(validator) do
    validator.is_valid
  end

  defp valid_loan_value?(proposal) do
    proposal.loan_value >= 30_000 && proposal.loan_value <= 3_000_000
  end

  defp valid_number_of_monthly_installments?(proposal) do
    proposal.number_of_monthly_installments >= 24 &&
      proposal.number_of_monthly_installments <= 180
  end
end
