class UsersController < ApplicationController
  before_action :user, only: [:pin, :pin_check, :main_screen, :show, :take_cash, :put_cash, :transaction, :update]

  def insert_card
    render :insert_card
  end

  def pin
    render :pin
  end

  def pin_check
    if user.pin.to_s == params[:user][:pin]
      user.correct_pin
      redirect_to controller: :users, action: :main_screen, id: user.id
    else
      user.incorrect_pin
      redirect_to controller: :users, action: :pin, incorrect_pin: true
    end
  end

  def card_number_check
    @user = User.find_by(card_number: params[:user][:card_number])
    if @user
      redirect_to controller: :users, action: :pin, id: @user.id
    else
      redirect_to controller: :users, action: :insert_card, invalid_card: true
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

  def update
    case params[:subaction]
    when 'take_cash'
      if user.balance >= user_params[:balance].to_i
        user.update(balance: user.balance - user_params[:balance].to_i)
        message = { notice: "Take your money" }
      else
        message = { alert: "Not enogh money" }
      end
    when 'put_cash'
      user.update(balance: user.balance + user_params[:balance].to_i)
      message = { notice: "Thanks" }
    when 'transaction'
      @payee = User.find_by(card_number: user_params[:card_number])
      if @payee && user.balance >= user_params[:balance].to_i
        binding.pry
        @payee.update(balance: @payee.balance + user_params[:balance].to_i)
        user.update(balance: user.balance - user_params[:balance].to_i)
        message = { notice: "Transaction done" }
      else
        message = { alert: "Not enogh money" } if user.balance <= user_params[:balance].to_i
        message = { alert: "Wrong card number" } unless @payee
      end
    end
    redirect_to main_screen_user_path, message
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:balance, :card_number)
  end

  def previous_action
    Rails.application.routes.recognize_path(request.referrer)[:action]
  end
end
