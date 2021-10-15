class WebhooksController < Telegram::Bot::UpdatesController
  def start!
    respond_with :message, text: 'Hello!'
  end
end
