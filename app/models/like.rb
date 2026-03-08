class Like < ApplicationRecord
  belongs_to :user
  belongs_to :datum

  validates :user_id, uniqueness: { scope: :datum_id }
end
