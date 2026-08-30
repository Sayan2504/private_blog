class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy

  # Name is the one profile field the app actually renders — it fronts the
  # account page and the avatar — so it is asked for at sign-up and required.
  # Address, mobile and interests are collected there too but left optional:
  # they are things a reader may reasonably not want to hand over just to
  # write a post, and nothing in the app breaks without them.
  validates :name, presence: true

  # Deliberately permissive. Numbers arrive with country codes, spaces, dashes
  # and brackets depending on where someone is, and a strict pattern here
  # rejects valid numbers far more often than it catches typos.
  validates :mobile_number,
            format: { with: /\A[\d+][\d\s()\-.]{5,19}\z/, message: "should look like a phone number" },
            allow_blank: true

  # Accounts predating the profile fields have no name, and the account page
  # still has to call them something.
  def display_name
    name.presence || email.to_s.split("@").first
  end

  # The form posts one comma-separated line, because that is the least
  # annoying way to type a short list. The column underneath is a real array,
  # so the split happens here rather than leaving every reader of the
  # attribute to do it.
  def interests=(value)
    super(normalize_interests(value))
  end

  # The round trip back into the text field.
  def interests_text
    interests.join(", ")
  end

  private

  def normalize_interests(value)
    list = value.is_a?(String) ? value.split(",") : Array(value)
    list.map { |interest| interest.to_s.strip }.reject(&:blank?).uniq
  end
end
