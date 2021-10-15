class User < ApplicationRecord
  validates :nickname, :firstname, :lastname, :chat_id, presence: true
end
