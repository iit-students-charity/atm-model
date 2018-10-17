class UsersController < ApplicationController
  MAIN_PATHS = { show: 'user_path',
                 take_cash: 'take_cash_user_path',
                 put_cash: 'put_cash_user_path',
                 transaction: 'transaction_user_path' }

  before_action :user, only: [:pin, :main_screen]
  before_action :check_user, only: [:show, :take_cash, :put_cash, :transaction]
  before_action :unauthorize_user, only: [:show, :take_cash, :put_cash, :transaction]

  def insert_card
    render :insert_card
  end

  def pin
    @next_action = params[:next_action]
    render :pin
  end

  def pin_check
    if user.pin.to_s == params[:user][:pin]
      user.correct_pin
      user.performed!
      path = MAIN_PATHS[params[:next_action].to_sym] || 'main_screen_user_path'
      redirect_to eval(path), id: user.id
    else
      user.incorrect_pin
      redirect_to pin_user_path(user, incorrect_pin: "true", next_action: params[:next_action])
    end
  end

  def card_number_check
    @user = User.find_by(card_number: params[:user][:card_number])
    if @user
      redirect_to pin_user_path(@user)
    else
      redirect_to insert_card_path invalid_card: "true"
    end
  end

  def main_screen
    render :main_screen
  end

  def show
    render :show
  end

  def take_cash
    render :take_cash
  end

  def put_cash
    render :put_cash
  end

  def transaction
    render :transaction
  end

  def update_take_cash
    if enough_money?
      user.update(balance: user.balance - user_params[:balance].to_i)
      redirect_to main_screen_user_path, notice: "Pleace, ake your money"
    else
      redirect_to main_screen_user_path, alert: "Error. Not enogh money"
    end
  end

  def update_put_cash
    user.update(balance: user.balance + user_params[:balance].to_i)
    redirect_to main_screen_user_path, notice: "Operation was successful"
  end

  def update_transaction
    if payee && enough_money?
      payee.update(balance: @payee.balance + user_params[:balance].to_i)
      user.update(balance: user.balance - user_params[:balance].to_i)
      redirect_to main_screen_user_path, notice: "Transaction was successful"
    else
      redirect_to main_screen_user_path, alert: "Error. Not enogh money" unless enough_money?
      redirect_to main_screen_user_path, alert: "Error. Wrong card number" unless payee
    end
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def payee
    @payee = User.find_by(card_number: user_params[:card_number])
  end

  def check_user
    redirect_to pin_user_path(user, next_action: action_name) unless user.authorized?
  end

  def unauthorize_user
    user.unperformed!
  end

  def user_params
    params.require(:user).permit(:balance, :card_number)
  end

  def enough_money?
    user.balance >= user_params[:balance].to_i
  end
end
