class Post < ApplicationRecord
  has_rich_text :content

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :drafts, -> { where(published_at: nil).order(updated_at: :desc) }

  def published?
    published_at.present?
  end

  def reading_time
    words_per_minute = 200
    word_count = content.to_plain_text.split.size
    [ (word_count / words_per_minute.to_f).ceil, 1 ].max
  end

  private

  def generate_slug
    self.slug = title.to_s.parameterize if slug.blank? && title.present?
  end
end
