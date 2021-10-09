defmodule Fixtures.ProposalFixture do
  alias Core.{Proponent, Proposal, Warranty}

  @fields %{id: 1, loan_value: 35_000, number_of_monthly_installments: 120}
  @proponent_fields %{id: 1, name: "Alan", age: 28, monthly_income: 4_000, main: false}
  @main_proponent_fields %{id: 1, name: "Alan", age: 28, monthly_income: 4_000, main: true}

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

  def add_main_proponent(proposal, params \\ %{}) do
    new_params =
      params
      |> Enum.into(@main_proponent_fields)

    proponent = Map.merge(%Proponent{}, new_params)
    %{proposal | proponents: [proponent | proposal.proponents]}
  end
end
