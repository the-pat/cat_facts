defmodule CatFacts.DailyDose do
  use GenServer

  alias CatFacts.{Fact, Image}

  ## Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  ## Server

  def init(:ok) do
    schedule_dose()

    {:ok, []}
  end

  def handle_info(:daily_dose, state) do
    schedule_dose()

    fact_task = Task.async(&Fact.random/0)
    image_task = Task.async(&Image.random/0)

    {:ok, fact} = Task.await(fact_task)
    {:ok, image} = Task.await(image_task)

    IO.inspect({fact, image})
    {:noreply, state}
  end

  ## Helpers
  defp schedule_dose() do
    {:ok, start_time} = Time.new(15, 0, 0)
    ms_past_start = abs(Time.diff(start_time, Time.utc_now(), :millisecond))
    ms_until_start = :timer.hours(24) - ms_past_start

    Process.send_after(self(), :daily_dose, ms_until_start)
  end
end
