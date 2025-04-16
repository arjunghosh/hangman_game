class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = User.find_or_create_by(provider: auth['provider'], uid: auth['uid']) do |u|
      u.name = auth['info']['name']
      u.email = auth['info']['email']
      u.image = auth['info']['image']
      u.coins = 0
      u.opt_in_email = true
      u.active = true
    end
    user.update(active: true)
    session[:user_id] = user.id
    redirect_to root_path, notice: 'Signed in!'
  end

  def destroy
    if current_user
      current_user.update(active: false)
    end
    session[:user_id] = nil
    redirect_to root_path, notice: 'Signed out!'
  end

  private
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
