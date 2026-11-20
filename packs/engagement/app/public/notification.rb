class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read_at: nil) }
  scope :recent, -> { includes(:actor, :notifiable).order(created_at: :desc).limit(30) }

  def self.notify!(recipient:, actor:, notifiable:, action:)
    return if recipient.blank? || recipient.id == actor.id

    create!(recipient: recipient, actor: actor, notifiable: notifiable, action: action)
  end

  def read?
    read_at.present?
  end
end
