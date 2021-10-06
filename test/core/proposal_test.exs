defmodule Core.ProposalTest do
  use ExUnit.Case, async: true

  alias Core.Proposal

  describe "new/1" do
    test "should return a new proposal when all params are passed" do
      params = %{
        id: 1,
        loan_value: 40_000,
        number_of_monthly_installments: 120
      }

      expected_proposal = %Proposal{
        id: 1,
        loan_value: 40_000,
        number_of_monthly_installments: 120
      }

      assert Proposal.new(params) == expected_proposal
    end
  end
end
