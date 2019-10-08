defmodule CatFacts.Fact do
  use GenServer

  ## Client

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def random() do
    GenServer.call(__MODULE__, {:random})
  end

  ## Server

  def init(:ok) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://cat-fact.herokuapp.com"},
      Tesla.Middleware.JSON
    ]

    {:ok, Tesla.client(middleware)}
  end

  def handle_call({:random}, _from, client) do
    {:ok, %{body: %{"text" => text}}} = Tesla.get(client, "/facts/random")

    {:reply, text, client}
  end
end
