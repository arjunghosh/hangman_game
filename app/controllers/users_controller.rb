class UsersController < ApplicationController
  before_action :require_login

  def toggle_email
    user = User.find(session[:user_id])
    user.update(opt_in_email: !user.opt_in_email)
    redirect_to root_path, notice: "Email notifications #{user.opt_in_email ? 'enabled' : 'disabled'}!"
  end

  private
  def require_login
    redirect_to root_path unless session[:user_id]
  end
end
