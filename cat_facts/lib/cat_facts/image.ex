defmodule CatFacts.Image do
  def random(attempts \\ 0) do
    client()
    |> Tesla.get("/images/search")
    |> parse(attempts)
  end

  defp client() do
    # TODO: create a config file
    key = ""

    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.thecatapi.com/v1"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"x-api-key", key}]}
    ]

    Tesla.client(middleware)
  end

  defp parse({:ok, %{body: body}}, _) do
    body
    |> List.first()
    |> Map.fetch("url")
  end

  defp parse(_, attempts) when attempts < 5 do
    random(attempts + 1)
  end

  defp parse({_, response}, _) do
    {:error, {"Unexpected response", response}}
  end
end
