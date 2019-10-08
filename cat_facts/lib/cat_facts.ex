defmodule CatFacts do
  use Application

  def start(_type, _args) do
    children = [
      CatFacts.DailyDose
    ]

    opts = [strategy: :one_for_one, name: CatFacts.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
