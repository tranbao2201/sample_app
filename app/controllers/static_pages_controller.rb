class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @feed_items = Kaminari.paginate_array(Micropost.list_new_micropost(list_id)
                          .sort_desc_by_time).page(params[:page])
                          .per(Settings.micropost.page)
  end

  def help; end

  def about; end

  def contact; end

  private

  def list_id
    Relationship.list_followed_id(current_user.id)
                .pluck(:followed_id).push(current_user.id)
  end
end
