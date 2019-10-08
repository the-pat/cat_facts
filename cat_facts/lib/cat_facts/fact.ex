defmodule CatFacts.Fact do
  def random() do
    client()
    |> Tesla.get("/facts/random")
    |> parse()
  end

  defp client() do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://cat-fact.herokuapp.com"},
      Tesla.Middleware.JSON
    ]

    Tesla.client(middleware)
  end

  defp parse({:ok, %{body: %{"text" => text}}}) do
    {:ok, text}
  end

  defp parse({_, response}) do
    {:error, {"Unexpected response", response}}
  end
end
