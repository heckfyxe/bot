class WebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    save_context :rename!
    respond_with :message, text: 'Вставай, самурай! Введи свое имя и фамилию'
  end

  def rename!(firstname = nil, lastname = nil, *)
    if firstname && lastname
      # User.upsert({ nickname: username, firstname: firstname, lastname: lastname }, unique_by: :nickname)
      respond_with :message, text: "Теперь ты #{username || 'nil'} #{firstname || 'nil'} #{lastname || 'nil'}"
    else
      save_context :rename!
      respond_with :message, text: 'Введи имя и фамилию'
    end
  end
end
