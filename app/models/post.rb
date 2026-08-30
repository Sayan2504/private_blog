class Post < ApplicationRecord
  belongs_to :user
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

  # Slugs are generated once and then left alone, so a published URL never
  # moves under a reader who bookmarked it — retitling a post changes the
  # heading, not the address.
  #
  # Uniqueness is resolved here rather than left to the validation. Two posts
  # called "Notes" is an ordinary thing to want, and the old version turned it
  # into "Slug has already been taken" — an error about a field that does not
  # appear anywhere in the form and that the author has no way to act on.
  # A numbered suffix is what every other publishing tool does with a
  # collision, and it needs no explaining.
  def generate_slug
    return if slug.present? || title.blank?

    # A title of nothing but punctuation or emoji parameterizes to an empty
    # string, which would fail the presence validation with an equally
    # unactionable message.
    base = title.to_s.parameterize.presence || "post"

    candidate = base
    suffix = 1

    while slug_taken?(candidate)
      suffix += 1
      candidate = "#{base}-#{suffix}"
    end

    self.slug = candidate
  end

  def slug_taken?(candidate)
    Post.where(slug: candidate).where.not(id: id).exists?
  end
end
