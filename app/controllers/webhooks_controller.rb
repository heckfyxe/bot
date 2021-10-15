class Telegram::WebhookController < Telegram::Bot::UpdatesController
  def start!
    respond_with :message, text: 'Hello!'
  end
end
