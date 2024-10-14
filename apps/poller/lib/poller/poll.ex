
defmodule Poller.Poll do
  alias __MODULE__
  alias Poller.Question
  @doc """
    . create a Poll
      > alias Poller.{Choice, Question, Poll}
      [Poller.Choice, Poller.Question, Poller.Poll]

      .. create choices
        > choice1 = Choice.new(1, "John", 0)
        %Poller.Choice{id: 1, description: "John", party: 0}
        > choice2 = Choice.new(2, "Mary", 1)
        %Poller.Choice{id: 2, description: "Mary", party: 1}

      .. create question
        > question = Question.new(1, "US Senator")
        %Poller.Question{id: 1, description: "US Senator", choices: []}

      .. add choices to the question
        > question = Question.add_choice(question, choice1)
        %Poller.Question{
          id: 1,
          description: "US Senator",
          choices: [%Poller.Choice{id: 1, description: "John", party: 0}]
        }
        > question = Question.add_choice(question, choice2)
        %Poller.Question{
          id: 1,
          description: "US Senator",
          choices: [
            %Poller.Choice{id: 2, description: "Mary", party: 1},
            %Poller.Choice{id: 1, description: "John", party: 0}
          ]
        }

      .. create a new poll
        > poll = Poll.new(1)
        %Poller.Poll{district_id: 1, questions: [], votes: %{}}

      .. add question to the poll
        > poll = Poll.add_question(poll, question)
        %Poller.Poll{
          district_id: 1,
          questions: [
            %Poller.Question{
              id: 1,
              description: "US Senator",
              choices: [
                %Poller.Choice{id: 2, description: "Mary", party: 1},
                %Poller.Choice{id: 1, description: "John", party: 0}
              ]
            }
          ],
          votes: %{1 => 0, 2 => 0}
        }

    . add a vote
      > Poll.vote(poll, 1)
      %Poller.Poll {
        district_id: 1,
        questions: [
          %Poller.Question{
            id: 1,
            description: "US Senator",
            choices: [
              %Poller.Choice{id: 2, description: "Mary", party: 1},
              %Poller.Choice{id: 1, description: "John", party: 0}
            ]
          }
        ],
        votes: %{1 => 1, 2 => 0}
                     --
      }



  """
  defstruct(
    district_id: nil,
    questions: [],
    votes: %{}      # %{ choice_1: vote_number, ... }
  )

  def new(district_id) do
    %Poll{ district_id: district_id }
  end

  def add_questions(poll, []), do: poll
  def add_questions(poll, [(%PollerDal.Questions.Question{} = question) | questions]) do
    votes = init_votes(poll.votes, question)
    question = Question.new(question)

    poll
    |> add_question(question)
    |> Map.put(:votes, votes)
    |> add_questions(questions)
  end

  def add_question(poll, question) do
    questions = [question | poll.questions]
    Map.put(poll, :questions, questions)
  end

  defp init_votes(votes, %PollerDal.Questions.Question{} = question) do
    question.choices
    |> Enum.map(fn %PollerDal.Choices.Choice{} = choice ->
        votes = choice.votes || 0
        {choice.id, votes}
      end)
    |> Enum.into(votes)
  end

  def vote(poll, choice_id) do
    do_vote(poll, choice_id, Map.has_key?(poll.votes, choice_id))
  end

  defp do_vote(poll, choice_id, _has_choice = true) do
    votes = Map.update!(poll.votes, choice_id, &(&1 + 1))
    Map.put(poll, :votes, votes)
  end

  defp do_vote(poll, _choice_id, _has_choice = false), do: poll
end
