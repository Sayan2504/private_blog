class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :count, numericality: { greater_than: 0 }
  validates :post_id, uniqueness: { scope: :user_id }
end

