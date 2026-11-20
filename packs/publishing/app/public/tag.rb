class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :slug, presence: true, uniqueness: true

  before_validation :normalize_name_and_slug

  scope :popular, -> {
    joins(:post_tags).group(:id).order(Arel.sql("COUNT(post_tags.id) DESC, tags.name ASC"))
  }

  def to_param
    slug
  end

  private

  def normalize_name_and_slug
    self.name = name.to_s.strip.downcase
    self.slug = name.parameterize if slug.blank? && name.present?
  end
end

