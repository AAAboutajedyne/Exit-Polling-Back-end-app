defmodule Poller.Question do
  alias __MODULE__
  alias Poller.Choice

  defstruct(
    id: nil,
    description: nil,
    choices: []
  )

  def new(id, description) do
    %Question{ id: id, description: description }
  end

  def new(%PollerDal.Questions.Question{id: id, description: description, choices: choices}) do
    new(id, description)
    |> add_choices(choices)
  end

  def add_choices(question, []), do: question
  def add_choices(question, [(%PollerDal.Choices.Choice{id: id, description: description, party: party}) | choices]) do
    choice = Choice.new(id, description, party)

    question
    |> add_choice(choice)
    |> add_choices(choices)
  end

  def add_choice(question, choice) do
    choices = [choice | question.choices]
    Map.put(question, :choices, choices)
  end

end
