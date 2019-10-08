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

    # TODO: run async, handle errors
    {:ok, fact} = Fact.random()
    {:ok, image} = Image.random()

    IO.inspect({fact, image})
    {:noreply, state}
  end

  ## Helpers

  defp schedule_dose() do
    Process.send_after(self(), :daily_dose, :timer.hours(24))
  end
end
