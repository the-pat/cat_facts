defmodule CatFacts.Message do
  defp send_mutiple(numbers, from, body, url) do
    sent_numbers =
      numbers
      |> Enum.map(fn to -> Task.async(&send(&1, from, fact, url)) end)
      |> Task.yield_many(5000)
      |> Enum.map(fn {task, res} -> res || Task.shutdown(task, :brutal_kill) end)
      |> Enum.filter(&match?({:ok, _}, &1))
      |> Enum.map(fn {:ok, value} -> value end)

    {:ok, sent_numbers}
  end

  defp send(to, from, body, url) do
    ExTwilio.Message.create(to: to, from: from, body: body, media_url: url)
  end
end
