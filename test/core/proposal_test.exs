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

  describe "valid?/1" do
    test "loan should be between 30k and 3M" do
      invalid_low_value_proposal = %Proposal{
        id: 1,
        loan_value: 29_999,
        number_of_monthly_installments: 120
      }

      invalid_high_value_proposal = %Proposal{
        id: 1,
        loan_value: 3_000_001,
        number_of_monthly_installments: 120
      }

      valid_proposal = %Proposal{
        id: 1,
        loan_value: 30_000,
        number_of_monthly_installments: 120
      }

      assert Proposal.valid?(invalid_low_value_proposal) == false
      assert Proposal.valid?(invalid_high_value_proposal) == false
      assert Proposal.valid?(valid_proposal) == true
    end

    test "loan should be paid between 24 and 180 months" do
      invalid_smaller_number_of_monthly_installments = %Proposal{
        id: 1,
        loan_value: 40_000,
        number_of_monthly_installments: 23
      }

      invalid_higher_number_of_monthly_installments = %Proposal{
        id: 1,
        loan_value: 40_000,
        number_of_monthly_installments: 181
      }

      valid_proposal_minimum_number_of_monthly_installments = %Proposal{
        id: 1,
        loan_value: 40_000,
        number_of_monthly_installments: 24
      }

      valid_proposal_maximum_number_of_monthly_installments = %Proposal{
        id: 1,
        loan_value: 40_000,
        number_of_monthly_installments: 180
      }

      assert Proposal.valid?(invalid_smaller_number_of_monthly_installments) == false
      assert Proposal.valid?(invalid_higher_number_of_monthly_installments) == false
      assert Proposal.valid?(valid_proposal_minimum_number_of_monthly_installments) == true
      assert Proposal.valid?(valid_proposal_maximum_number_of_monthly_installments) == true
    end
  end
end
