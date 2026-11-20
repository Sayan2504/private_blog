class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :body, presence: true, length: { maximum: 2000 }

  scope :chronological, -> { includes(:user).order(created_at: :asc) }
end

