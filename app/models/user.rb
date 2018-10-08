class User < ApplicationRecord
  enum status: [:active, :blocked]

  validates :card_number, presence: true
  validates :pin,         presence: true
  validates :balance,     presence: true
  validates :attempts,    presence: true
end
