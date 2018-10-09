class UsersController < ApplicationController
  # before_action :user, except: :insert_card
  # before_action :check_pin, only: :main_screen

  def insert_card
    render :insert_card
  end

  def pin
    binding.pry

    render :pin
  end

  def pin_check

  end

  def card_number_check
    user = User.find_by(card_number: params[:user][:card_number])
    if user
      redirect_to controller: :users, action: :pin, id: user.id
    else
      redirect_to controller: :users, action: :pin, invalid_card: true
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

  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params

  end
end
