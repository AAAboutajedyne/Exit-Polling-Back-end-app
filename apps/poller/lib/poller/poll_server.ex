defmodule Poller.PollServer do
  use GenServer

  alias Poller.{Poll, PollSaveScheduler, PubSub}
  alias PollerDal.Questions
  alias PollerDal.Choices

  def start_link(district_id) do
    name = district_name(district_id)
    GenServer.start_link(__MODULE__, district_id, name: name)
  end

  defp district_name(district_id), do: :"district:#{district_id}"

  def get_poll(district_id) do
    name = district_name(district_id)
    GenServer.call(name, :get_poll)
  end

  def vote(district_id, choice_id) do
    name = district_name(district_id)
    GenServer.call(name, {:vote, choice_id})
  end

  def add_question(district_id, question) do
    name = district_name(district_id)
    GenServer.call(name, {:add_question, question})
  end

  def pidOf(district_id) do
    name = district_name(district_id)
    Process.whereis(name)   # returns the PID or port identifier registered under name |
                            # nil if the name is not registered
  end

  def alive?(district_id) do
    pidOf(district_id) !== nil
  end

  #---- Callbacks ------------------------------
  @impl true
  def init(district_id) do
    # PollSaveScheduler.schedule_save()

    # poll = Poll.new(district_id)    #<== instead of creating a new poll
    poll = init_poll(district_id)     #    we get it from database
    {:ok, poll}
  end

  defp init_poll(district_id) do
    questions = Questions.list_questions_by_district_id(district_id)
    # IO.puts("Questions: " <> inspect(questions))

    district_id
    |> Poll.new()
    |> Poll.add_questions(questions)
  end

  @impl true
  def handle_call(:get_poll, _from, poll) do
    {:reply, poll, poll}
  end

  @impl true
  def handle_call({:vote, choice_id}, _from, poll) do
    poll = Poll.vote(poll, choice_id)
    votes = Map.get(poll.votes, choice_id, 0)
    PubSub.broadcast_district_votes(poll.district_id, choice_id, votes)
    {:reply, poll, poll}
  end

  @impl true
  def handle_call({:add_question, question}, _from, poll) do
    poll = Poll.add_question(poll, question)
    {:reply, poll, poll}
  end

  @impl true
  def handle_info(:save, poll) do     #<== handles other messages (e.g. sent via Process.send, ...)
    save_votes(poll)                  # in our case Process.send_after used in PollSaveScheduler.schedule_save
                                      # function
    PollSaveScheduler.schedule_save()

    {:noreply, poll}
  end

  @impl true
  def terminate(_reason, poll), do: save_votes(poll)

  #---- Private ------------------------------

  defp save_votes(poll) do
    poll.votes
    |> Map.keys()
    |> Choices.list_choices_by_choice_ids()
    |> Enum.each(fn %Choices.Choice{} = choice ->
      current_votes = Map.get(poll.votes, choice.id, choice.votes)

      if(current_votes != choice.votes) do
        Choices.update_choice(choice, %{"votes" => current_votes })
      end
    end)
  end

end
