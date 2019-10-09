defmodule CatFacts.Fact do
  def random(attempts \\ 0) do
    client()
    |> Tesla.get("/facts/random")
    |> parse(attempts)
  end

  defp client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://cat-fact.herokuapp.com"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  defp parse({:ok, %{body: %{"text" => text}}}, _) do
    {:ok, text}
  end

  defp parse(_, attempts) when attempts < 5 do
    random(attempts + 1)
  end

  defp parse({_, response}, _) do
    {:error, {"Unexpected response", response}}
  end
end
