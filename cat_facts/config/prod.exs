import Config

config :cat_facts,
  cat_api_key: System.fetch_env!("CAT_API_KEY"),
  from_number: System.fetch_env!("TWILIO_FROM_NUMBER")

config :ex_twilio,
  account_sid: System.fetch_env!("TWILIO_ACCOUNT_SID"),
  auth_token: System.fetch_env!("TWILIO_AUTH_TOKEN")
