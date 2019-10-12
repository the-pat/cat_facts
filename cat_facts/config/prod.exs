import Config

config :cat_facts,
  cat_api_key: System.fetch_env!("CAT_API_KEY")
