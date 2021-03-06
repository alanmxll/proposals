defmodule Fixtures.ProposalFixture do
  alias Core.{Proponent, Proposal, Warranty}

  @fields %{id: 1, loan_value: 35_000, number_of_monthly_installments: 120}
  @proponent_fields %{id: 1, name: "Alan", age: 28, monthly_income: 4_000, main: false}
  @warranty_fields %{id: 1, value: 71_000, province: "CE"}
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
    warranties = default_warranties()

    %{proposal | proponents: proponents, warranties: warranties}
  end

  def default_proponents() do
    [
      %Proponent{name: "Laise", age: 27, monthly_income: 5_000, main: false},
      %Proponent{name: "Maia", age: 32, monthly_income: 8_000, main: true}
    ]
  end

  def default_warranties() do
    [
      %Warranty{value: 90_000, province: "CE"}
    ]
  end

  def proposal_without_proponents(params \\ %{}) do
    proposal = base_proposal(params)
    %{proposal | proponents: [], warranties: default_warranties()}
  end

  def proposal_without_warranties(params \\ %{}) do
    proposal = base_proposal(params)
    %{proposal | proponents: default_proponents(), warranties: []}
  end

  def add_proponent(proposal, params \\ %{}) do
    new_params =
      params
      |> Enum.into(@proponent_fields)

    proponent = Map.merge(%Proponent{}, new_params)
    %{proposal | proponents: [proponent | proposal.proponents]}
  end

  def add_warranty(proposal, params \\ %{}) do
    new_params = params |> Enum.into(@warranty_fields)

    warranty = Map.merge(%Warranty{}, new_params)
    %{proposal | warranties: [warranty | proposal.warranties]}
  end

  def add_main_proponent(proposal, params \\ %{}) do
    new_params =
      params
      |> Enum.into(@main_proponent_fields)

    proponent = Map.merge(%Proponent{}, new_params)
    %{proposal | proponents: [proponent | proposal.proponents]}
  end
end
