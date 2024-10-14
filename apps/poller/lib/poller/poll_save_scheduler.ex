defmodule Poller.PollSaveScheduler do

  # @save_time_interval 10 * 60 * 1000   ## 10min
  @save_time_interval 10 * 1000        ## 10 sec

  def schedule_save(), do: Process.send_after(self(), :save, @save_time_interval)
end
