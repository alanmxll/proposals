defmodule Core.Proposal do
  defstruct [:id, :loan_value, :number_of_monthly_installments]

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def valid?(proposal) do
    proposal.loan_value >= 30_000 && proposal.loan_value <= 3_000_000
  end
end
