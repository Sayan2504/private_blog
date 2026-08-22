# frozen_string_literal: true

# A toast, not a banner. Flashes float in the top-right corner of the content
# pane, so a confirmation never covers a page heading and never shifts the
# layout underneath it.
#
# The surface itself is neutral in both variants — the same tinted glass the
# header clusters use — and the meaning is carried by one coloured icon. A
# full green or red panel read as part of the page; a small mark on the app's
# own chrome reads as the app talking back.
class FlashComponent < ViewComponent::Base
  VARIANTS = {
    notice: {
      accent: "text-emerald-600 dark:text-emerald-400",
      icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>'
    },
    alert: {
      accent: "text-red-600 dark:text-red-400",
      icon: '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3.75m0 3.75h.008M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>'
    }
  }.freeze

  def initialize(type:, message:)
    @type = type.to_sym
    @message = message
  end

  def render?
    @message.present?
  end

  private

  attr_reader :message

  def variant
    VARIANTS.fetch(@type, VARIANTS[:notice])
  end

  def accent_class
    variant[:accent]
  end

  def icon_path
    variant[:icon].html_safe
  end
end
