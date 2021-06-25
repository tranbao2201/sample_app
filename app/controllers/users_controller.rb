class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :admin_user, only: :destroy
  before_action :load_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def index
    @users = Kaminari.paginate_array(User.sort_asc_by_name)
                     .page(params[:page]).per(Settings.user.per_page)
  end

  def show
    redirect_to root_url unless @user.activated?
    @microposts = Kaminari.paginate_array(@user.microposts)
                          .page(params[:page]).per(Settings.micropost.per_page)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if @user.send_activation_email
        flash[:info] = t "active_account"
      else
        flash[:danger] = t "mail_error"
      end
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "update_success"
      redirect_to @user
    else
      flash[:danger] = t "update_failed"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "delete_success"
    else
      flash[:danger] = t "delete_failed"
    end
    redirect_to users_url
  end

  def following
    @title = t "following"
    @user = User.find(params[:id])
    @users = Kaminari.paginate_array(@user.following).page(params[:page])
    render "show_follow"
  end

  def followers
    @title = t "followers"
    @user = User.find(params[:id])
    @users = Kaminari.paginate_array(@user.followers).page(params[:page])
    render "show_follow"
  end

  private

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user

    flash[:danger] = t "not_found_user"
    redirect_to root_url
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def correct_user
    redirect_to(root_url) unless @user == current_user
  end
end
