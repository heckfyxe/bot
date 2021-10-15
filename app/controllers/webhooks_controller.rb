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
    save_context :keyboard!
    case value
    when 'Занять'
      keyboard = place_keyboard
      if keyboard[:keyboard].empty?
        respond_with :message, text: 'Мест нет...', reply_markup: main_keyboard
      else
        respond_with :message, text: 'Выбери место', reply_markup: keyboard
      end
    when 'Уйти'
      free_place
      respond_with :message, text: 'Bye'
    when 'Показать список'
      respond_with :message, text: queue_text
    when /\d+/
      if take_place(value.to_i)
        respond_with :message, text: 'Успешно', reply_markup: main_keyboard
      else
        respond_with :message, text: 'Уже занято', reply_markup: place_keyboard
      end
    else
      respond_with :message, text: 'Действуй!', reply_markup: main_keyboard
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
      keyboard: [%w[Занять Уйти],
                 %w[Показать список]],
      resize_keyboard: true,
      one_time_keyboard: true
    }
  end

  def place_keyboard
    places = User.pluck(:place)
    places = (1..places.count).to_a - places.compact.uniq
    places = places.map(&:to_s).in_groups_of(4, false)
    {
      keyboard: places,
      resize_keyboard: true,
      one_time_keyboard: true
    }
  end

  def take_place(place)
    return false if User.exists?(place: place)

    User.where(nickname: from[:username]).update(place: place)
  end

  def free_place
    User.where(nickname: from[:username]).update(place: nil)
  end

  def queue_text
    users = User.where.not(place: nil)
    users.map { |user| "#{user.place} @#{user.nickname} #{user.firstname} #{user.lastname}" }.join("\n")
  end
end
