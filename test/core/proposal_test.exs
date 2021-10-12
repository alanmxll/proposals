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

    test "the sum of all warranties should be bigger than double of the loan value" do
      valid_proposal = valid_proposal()

      valid_proposal_with_one_warranty =
        proposal_without_warranties()
        |> add_warranty(%{id: 10, value: 71_000, province: "CE"})

      valid_proposal_with_two_warranties =
        proposal_without_warranties()
        |> add_warranty(%{id: 10, value: 35_000, province: "RN"})
        |> add_warranty(%{id: 10, value: 35_000, province: "RJ"})

      invalid_proposal_with_warranty =
        proposal_without_warranties()
        |> add_warranty(%{id: 10, value: 69_000, province: "RN"})

      assert Proposal.valid?(valid_proposal) == true
      assert Proposal.valid?(valid_proposal_with_one_warranty) == true
      assert Proposal.valid?(valid_proposal_with_two_warranties) == true
      refute Proposal.valid?(invalid_proposal_with_warranty) == true
    end

    test "PR, SC and RS should not be elegible provinces for warranties" do
      valid_proposal = valid_proposal()

      proposal_with_warranty_from_SC =
        proposal_without_warranties() |> add_warranty(%{id: 10, value: 71_000, province: "SC"})

      proposal_with_warranty_from_PR =
        proposal_without_warranties() |> add_warranty(%{id: 10, value: 71_000, province: "PR"})

      proposal_with_warranty_from_RS =
        proposal_without_warranties() |> add_warranty(%{id: 10, value: 71_000, province: "RS"})

      assert Proposal.valid?(valid_proposal) == true
      refute Proposal.valid?(proposal_with_warranty_from_SC) == true
      refute Proposal.valid?(proposal_with_warranty_from_PR) == true
      refute Proposal.valid?(proposal_with_warranty_from_RS) == true
    end
  end

  describe "Main proponent monthly income should follow those rules" do
    setup [:create_proposal_with_proponent]

    test "valid?/1 should be 4 times higher than the loan installment for 18 to 24 years old", %{
      proposal: proposal
    } do
      valid_proposal = proposal |> add_main_proponent(%{age: 18, monthly_income: 10_000})
      other_valid_proposal = proposal |> add_main_proponent(%{age: 24, monthly_income: 10_000})

      invalid_monthly_income_proposal =
        proposal |> add_main_proponent(%{age: 18, monthly_income: 9_000})

      assert Proposal.valid?(valid_proposal) == true
      assert Proposal.valid?(other_valid_proposal) == true
      refute Proposal.valid?(invalid_monthly_income_proposal) == true
    end

    test "valid?/1 should be 3 times higher than the loan installment for 25 to 50 years old", %{
      proposal: proposal
    } do
      valid_proposal = proposal |> add_main_proponent(%{age: 25, monthly_income: 8_000})
      other_valid_proposal = proposal |> add_main_proponent(%{age: 50, monthly_income: 8_000})

      invalid_monthly_income_proposal =
        proposal |> add_main_proponent(%{age: 50, monthly_income: 7_400})

      assert Proposal.valid?(valid_proposal) == true
      assert Proposal.valid?(other_valid_proposal) == true
      refute Proposal.valid?(invalid_monthly_income_proposal) == true
    end

    test "valid?/1 should be 2 times higher than the loan installment for above 50 years old", %{
      proposal: proposal
    } do
      valid_proposal = proposal |> add_main_proponent(%{age: 51, monthly_income: 5_000})

      invalid_monthly_income_proposal =
        proposal |> add_main_proponent(%{age: 51, monthly_income: 4_500})

      assert Proposal.valid?(valid_proposal) == true
      refute Proposal.valid?(invalid_monthly_income_proposal) == true
    end
  end

  defp create_proposal_with_proponent(context) do
    proposal =
      proposal_without_proponents(%{
        loan_value: 100_000,
        number_of_monthly_installments: 40
      })
      |> add_proponent()
      |> add_warranty(%{id: 100, value: 200_000, province: "CE"})

    {:ok, Map.put(context, :proposal, proposal)}
  end
end
