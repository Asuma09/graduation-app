class Datum < ApplicationRecord
  belongs_to :user

  belongs_to :parent, class_name: "Datum", optional: true
  has_many :replies, class_name: "Datum", foreign_key: :parent_id, dependent: :destroy
  has_many :likes, dependent: :destroy

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end
end
