defmodule CatFacts.Message do
  def send(to, from, body) do
    ExTwilio.Message.create(to: to, from: from, body: body)
  end

  def send(to, from, body, url) do
    ExTwilio.Message.create(to: to, from: from, body: body, media_url: url)
  end
end
