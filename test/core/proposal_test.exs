defmodule Core.ProposalTest do
  use ExUnit.Case, async: true

  alias Core.{Proponent, Proposal}

  @fields %{id: 1, loan_value: 35_000, number_of_monthly_installments: 120}
  @proponent_fields %{id: 1, name: "Alan", age: 28, monthly_income: 4_000, main: false}

  def base_proposal(params \\ %{}) do
    new_params =
      params
      |> Enum.into(@fields)

    Map.merge(%Proposal{}, new_params)
  end

  def valid_proposal(params \\ %{}) do
    proposal = base_proposal(params)

    proponents = default_proponents()
    # TODO: need to add default warranties

    %{proposal | proponents: proponents}
  end

  def default_proponents() do
    [
      %Proponent{name: "Laise", age: 27, monthly_income: 5_000, main: false},
      %Proponent{name: "Maia", age: 32, monthly_income: 8_000, main: true}
    ]
  end

  def proposal_without_proponents(params \\ %{}) do
    proposal = base_proposal(params)
    %{proposal | proponents: []}
  end

  def add_proponent(proposal, params \\ %{}) do
    new_params =
      params
      |> Enum.into(@proponent_fields)

    proponent = Map.merge(%Proponent{}, new_params)
    %{proposal | proponents: [proponent | proposal.proponents]}
  end

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
      invalid_proposal = proposal_without_proponents()
      valid_proposal = valid_proposal()

      assert Proposal.valid?(valid_proposal) == true
      refute Proposal.valid?(invalid_proposal) == true
    end
  end
end
