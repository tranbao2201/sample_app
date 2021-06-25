class Micropost < ApplicationRecord
  belongs_to :user
  scope :sort_desc_by_time, ->{order(created_at: :desc)}
  scope :feed, ->(id){where("user_id = ?", id)}
  scope :list_new_micropost, ->(list_id){where("user_id IN  (?)", list_id)}
  has_one_attached :image
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost
                                                                .content.max}
  validates :image, content_type: {in: ["image/jpeg", "image/gif", "image/png"],
                                   message: I18n.t("image_format")},
                    size:         {less_than: 5.megabytes,
                                   message: I18n.t("maximum_size")}

  def display_image
    image.variant(resize_to_limit: [500, 500])
  end
end
