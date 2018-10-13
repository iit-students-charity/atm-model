class User < ApplicationRecord
  enum status: [:active, :blocked]
  enum authorization: [:unperformed, :performed]

  validates :card_number, presence: true
  validates :pin,         presence: true
  validates :balance,     presence: true
  validates :attempts,    presence: true
  validates :status,      presence: true

  def correct_pin
    unlock! if active?
  end

  def incorrect_pin
    update_attributes(attempts: attempts + 1) unless block_required?
    block! if block_required?
  end

  def block_required?
    attempts >= 3
  end

  def reset_attempts
    update_attributes(attempts: 0)
  end

  def block!
    update_attributes(status: :blocked)
  end

  def unlock!
    reset_attempts
    update_attributes(status: :active)
  end

  def attempts_left
    3 - attempts
  end

  def authorized?
    authorization == 'performed'
  end
end
