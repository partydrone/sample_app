class ApplicationController < ActionController::Base
  protect_from_forgery

  def sign_in(user)
    cookies.permanent[:auth_token] = user.auth_token
  end

private

  def current_user
    @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def redirect_back_or(default)
    redirect_to session[:return_to] || default
    session.delete :return_to
  end

  def store_location
    session[:return_to] = request.fullpath
  end
end
