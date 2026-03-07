class Datum < ApplicationRecord
  belongs_to :user

  belongs_to :parent, class_name: "Datum", optional: true
  has_many :replies, class_name: "Datum", foreign_key: :parent_id, dependent: :destroy
end
