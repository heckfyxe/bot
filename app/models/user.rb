class User < ApplicationRecord
  validates :nickname, :firstname, :lastname, presence: true
end
