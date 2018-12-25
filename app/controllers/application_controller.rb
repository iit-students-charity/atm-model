class ApplicationController < ActionController::Base
  helper_method  :user

	protected

  def user
    @user ||= User.find(params[:id])
  end
end
