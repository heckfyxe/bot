class WebhooksController < Telegram::Bot::UpdatesController
  def start!(*)
    save_context :rename!
    respond_with :message, text: 'Вставай, самурай! Введи свое имя и фамилию'
  end

  def rename!(firstname = nil, lastname = nil, *)
    if !firstname && !lastname
      save_context :rename!
      respond_with :message, text: 'Введи имя и фамилию'
    else
      respond_with :message, text: "Теперь ты #{firstname} #{lastname}"
    end
  end
end
