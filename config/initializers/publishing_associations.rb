# Wire cross-pack associations without coupling identity/publishing to engagement.
Rails.application.config.to_prepare do
  User.has_many :posts, dependent: :destroy
  User.has_many :bookmarks, dependent: :destroy
  User.has_many :bookmarked_posts, through: :bookmarks, source: :post
  User.has_many :reactions, dependent: :destroy
  User.has_many :comments, dependent: :destroy

  User.has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  User.has_many :following, through: :active_follows, source: :followed
  User.has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  User.has_many :followers, through: :passive_follows, source: :follower

  User.has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  Post.has_many :bookmarks, dependent: :destroy
  Post.has_many :reactions, dependent: :destroy
  Post.has_many :comments, dependent: :destroy
end
