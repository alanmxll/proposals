defmodule Core.ProposalTest do
  use ExUnit.Case, async: true
  import Fixtures.ProposalFixture

  alias Core.{Proponent, Proposal}

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
      invalid_low_value_proposal = valid_proposal(%{loan_value: 29_999})
      invalid_high_value_proposal = valid_proposal(%{loan_value: 3_000_001})
      valid_proposal = valid_proposal(%{loan_value: 30_000})

      assert Proposal.valid?(invalid_low_value_proposal) == false
      assert Proposal.valid?(invalid_high_value_proposal) == false
      assert Proposal.valid?(valid_proposal) == true
    end

    test "loan should be paid between 24 and 180 months" do
      invalid_smaller_number_of_monthly_installments =
        valid_proposal(%{number_of_monthly_installments: 23})

      invalid_higher_number_of_monthly_installments =
        valid_proposal(%{number_of_monthly_installments: 181})

      valid_proposal_minimum_number_of_monthly_installments =
        valid_proposal(%{number_of_monthly_installments: 24})

      valid_proposal_maximum_number_of_monthly_installments =
        valid_proposal(%{number_of_monthly_installments: 180})

      assert Proposal.valid?(invalid_smaller_number_of_monthly_installments) == false
      assert Proposal.valid?(invalid_higher_number_of_monthly_installments) == false
      assert Proposal.valid?(valid_proposal_minimum_number_of_monthly_installments) == true
      assert Proposal.valid?(valid_proposal_maximum_number_of_monthly_installments) == true
    end

    test "loan should have at least 2 proponents" do
      invalid_proposal_no_proponents = proposal_without_proponents()
      valid_proposal = valid_proposal()

      assert Proposal.valid?(valid_proposal) == true
      refute Proposal.valid?(invalid_proposal_no_proponents) == true
    end

    test "should one proponent be the main one" do
      invalid_proposal_no_main_proponent =
        proposal_without_proponents()
        |> add_proponent()
        |> add_proponent()

      invalid_proposal_more_than_one_main_proponent =
        proposal_without_proponents()
        |> add_main_proponent()
        |> add_main_proponent()

      valid_proposal = valid_proposal()

      assert Proposal.valid?(valid_proposal) == true
      refute Proposal.valid?(invalid_proposal_no_main_proponent) == true
      refute Proposal.valid?(invalid_proposal_more_than_one_main_proponent) == true
    end

    test "all proponents need to be older than or equal to 18" do
      valid_proposal = valid_proposal()

      invalid_proposal_with_one_proponent_less_than_18 =
        proposal_without_proponents()
        |> add_proponent(%{age: 17})
        |> add_main_proponent()

      assert Proposal.valid?(valid_proposal) == true
      refute Proposal.valid?(invalid_proposal_with_one_proponent_less_than_18) == true
    end

    test "proposal needs to have at least one warranty" do
      valid_proposal = valid_proposal()
      proposal_without_warranty = proposal_without_warranties()

      assert Proposal.valid?(valid_proposal) == true
      refute Proposal.valid?(proposal_without_warranty) == true
    end
  end
end
