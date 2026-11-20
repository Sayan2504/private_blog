class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_one_attached :cover_image
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug
  after_commit :sync_search_vector, on: %i[ create update ]

  scope :published, -> { where.not(published_at: nil).order(published_at: :desc) }
  scope :drafts, -> { where(published_at: nil).order(updated_at: :desc) }
  scope :due_to_publish, -> { where(published_at: nil).where.not(scheduled_for: nil).where("scheduled_for <= ?", Time.current) }
  scope :with_associations, -> { includes(:user, :rich_text_content, :tags).with_attached_cover_image }
  scope :tagged_with, ->(slug) {
    return all if slug.blank?

    joins(:tags).where(tags: { slug: slug.to_s.downcase })
  }
  scope :search, ->(query) {
    return all if query.blank?

    q = query.to_s.strip
    where(
      "posts.search_vector @@ websearch_to_tsquery('english', :q) OR posts.title ILIKE :like OR posts.author ILIKE :like",
      q: q,
      like: "%#{sanitize_sql_like(q)}%"
    )
  }

  def self.find_by_slug_or_id!(param)
    find_by(slug: param) || find(param)
  end

  def to_param
    slug.presence || id&.to_s
  end

  def scheduled?
    !published? && scheduled_for.present?
  end

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(value)
    names = value.to_s.split(",").map { |n| n.strip.downcase }.reject(&:blank?).uniq.first(5)
    self.tags = names.map { |name| Tag.find_or_create_by!(name: name) }
  end

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

  def sync_search_vector
    self.class.where(id: id).update_all(
      [ "search_vector = to_tsvector('english', coalesce(title, '') || ' ' || coalesce(author, ''))" ]
    )
  end
end
