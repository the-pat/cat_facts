defmodule CatFacts.DailyDose do
  use GenServer

  alias CatFacts.{Fact, Image, Message}

  ## Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, {:ok, []}, name: __MODULE__)
  end

  def add_numbers(numbers) when is_list(numbers) do
    GenServer.cast(__MODULE__, {:add, numbers})
  end

  def remove_numbers(numbers) when is_list(numbers) do
    GenServer.cast(__MODULE__, {:remove, numbers})
  end

  ## Server

  def init(:ok) do
    schedule_dose()

    {:ok, []}
  end

  def handle_cast({:add, numbers_to_add}, numbers) do
    {:noreply, numbers_to_add ++ numbers}
  end

  def handle_cast({:remove, numbers_to_remove}, numbers) do
    {:noreply, numbers -- numbers_to_remove}
  end

  def handle_info(:daily_dose, numbers) do
    schedule_dose()

    dose = get_daily_dose(numbers)

    {:noreply, numbers}
  end

  ## Helpers

  defp schedule_dose() do
    {:ok, start_time} = Time.new(15, 0, 0)
    ms_past_start = abs(Time.diff(start_time, Time.utc_now(), :millisecond))
    ms_until_start = :timer.hours(24) - ms_past_start

    Process.send_after(self(), :daily_dose, ms_until_start)
  end

  defp get_daily_dose(numbers, attempts \\ 0) do
    with fact_task <- Task.async(&Fact.random/0),
         image_task <- Task.async(&Image.random/0),
         {:ok, fact} <- Task.await(fact_task),
         {:ok, image} <- Task.await(image_task)
         {:ok, sent_numbers} <- Message.send_messages(numbers, from_number(), fact, image) do
      {:ok, fact, image, sent_numbers}
    else
      _ when attempts >= 5 -> {:error, "Unable to send the daily dose of cat facts."}
      _ -> get_daily_dose(numbers, attempts + 1)
    end
  end

  defp from_number(), do: Application.get_env(:cat_facts, :from_number)
end
