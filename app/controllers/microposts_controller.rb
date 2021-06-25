class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = t "micropost_create"
    else
      flash[:danger] = t "create_micropost_failed"
    end
    redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost_delete"
    else
      flash[:danger] = t "mircopost_delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:danger] = t "micropost_not_exit"
    redirect_to root_url
  end
end
