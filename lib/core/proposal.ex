defmodule Core.Proposal do
  defstruct [:id, :loan_value, :number_of_monthly_installments]

  def new(fields) do
    struct!(__MODULE__, fields)
  end
end
