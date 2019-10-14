import Config

config :cat_facts,
  cat_api_key: "<api key>",
  from_number: "<from number>"

config :ex_twilio,
  account_sid: "<account sid>",
  auth_token: "<auth token>"

import_config "#{Mix.env()}.exs"
