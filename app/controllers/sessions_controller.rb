class SessionsController < ApplicationController
  before_action :find_user, only: [:create]
  def new; end

  def create
    if @user&.authenticate params[:session][:password]
      return handle_login_success @user if @user.activated?

      message = t "message"
      flash[:warning] = message
      redirect_to root_url
    else
      flash.now[:danger] = t "login_error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def find_user
    @user = User.find_by(email: params[:session][:email].downcase)
  end

  def handle_login_success user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or root_url
  end
end
