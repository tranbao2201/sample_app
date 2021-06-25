class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "reset_pass"
      redirect_to root_url
    else
      flash.now[:danger] = t "not_found_email"
      render :new
    end
  end

  def edit; end

  def update
    if @user.check_empty_password? params[:user][:password]
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_column(:reset_digest, nil)
      flash[:success] = t "reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t "not_found_user"
    redirect_to new_password_reset_url
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "error_reset"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "pass_expired"
    redirect_to new_password_reset_url
  end
end
