class WebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def start!(*)
    save_context :rename!
    respond_with :message, text: 'Вставай, самурай! Введи свое имя и фамилию'
  end

  def rename!(firstname = nil, lastname = nil, *)
    if firstname && lastname
      user = User.find_or_initialize_by(nickname: from[:username])
      user.firstname = firstname
      user.lastname = lastname
      user.save!
      save_context :keyboard!
      respond_with :message, text: "Теперь ты #{firstname} #{lastname}", reply_markup: main_keyboard
    else
      save_context :rename!
      respond_with :message, text: 'Введи имя и фамилию'
    end
  end

  def keyboard!(value = nil, *)
    case value
    when 'Занять'
      save_context :take_place!
      respond_with :message, text: 'Выбери место', reply_markup: place_keyboard
    when '1'...'12'
      respond_with :message, text: value
    else
      save_context :keyboard!
      respond_with :message, text: 'promt', reply_markup: main_keyboard
    end
  end

  def take_place!(value = nil, *)
    if value
      respond_with :message, text: "Place: #{value}"
    else
      save_context :take_place!
      respond_with :message, text: 'Выбери место', reply_markup: place_keyboard
    end
  end

  def me!(*)
    user = User.find_by(nickname: from[:username])
    if user
      respond_with :message, text: "#{user.firstname} #{user.lastname}"
    else
      save_context :rename!
      respond_with :message, text: 'Кто ты?'
    end
  end

  private

  def main_keyboard
    {
      keyboard: [%w[Занять Уйти]],
      resize_keyboard: true,
      one_time_keyboard: true
    }
  end

  def place_keyboard
    {
      keyboard: [[1, 2, 3, 4],
                 [5, 6, 7, 8],
                 [9, 10, 11, 12]],
      resize_keyboard: true,
      one_time_keyboard: true
    }
  end
end
