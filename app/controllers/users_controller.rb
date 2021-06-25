class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user
    flash[:danger] = I18n.t "not_found_user"
    redirect_to root_url
  end

  def create
    @user = User.new(user_params) # Not the final implementation!
    if @user.save
      log_in @user
      flash[:success] = I18n.t "welcome.home"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
