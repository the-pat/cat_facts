import Config

config :cat_facts,
  cat_api_key: "<api key>"

import_config "#{Mix.env()}.exs"
