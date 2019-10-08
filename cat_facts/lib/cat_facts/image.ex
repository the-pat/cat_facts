defmodule CatFacts.Image do
  def random() do
    client()
    |> Tesla.get("/images/search")
    |> parse()
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

  defp parse({:ok, %{body: body}}) do
    body
    |> List.first()
    |> Map.fetch("url")
  end

  defp parse({_, response}) do
    {:error, {"Unexpected response", response}}
  end
end
