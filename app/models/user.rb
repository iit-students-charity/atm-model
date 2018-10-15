class User < ApplicationRecord
  enum status: [:active, :blocked]
  enum authorization: [:unperformed, :performed]

  validates :card_number,   presence: true
  validates :pin,           presence: true
  validates :balance,       presence: true
  validates :attempts,      presence: true
  validates :status,        presence: true
  validates :authorization, presence: true
  validates :card_number,   numericality: true
  validates :pin,           numericality: true
  validates :balance,       numericality: { greater_than_or_equal_to: 0 }
  validates :attempts,      numericality: { greater_than_or_equal_to: 0 }
  validates :card_number,   length: { is: 16 }
  validates :pin,           length: { is: 4 }


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
