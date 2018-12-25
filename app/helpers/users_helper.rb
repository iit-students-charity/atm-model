module UsersHelper
  MAIN_PATHS = { show: 'user_path',
                 take_cash: 'take_cash_user_path',
                 put_cash: 'put_cash_user_path',
                 transaction: 'transaction_user_path' }

  def correct_pin?
    user.pin.to_s == params[:user][:pin]
  end
end
