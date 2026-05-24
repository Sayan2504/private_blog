# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  VARIANTS = {
    notice: { bg: "bg-green-50", border: "border-green-200", text: "text-green-800" },
    alert: { bg: "bg-red-50", border: "border-red-200", text: "text-red-800" }
  }.freeze

  def initialize(type:, message:)
    @type = type.to_sym
    @message = message
  end

  def call
    styles = VARIANTS[@type] || VARIANTS[:notice]

    content_tag :div, class: "max-w-4xl mx-auto px-4 mt-4" do
      content_tag :div, @message, class: "#{styles[:bg]} border #{styles[:border]} #{styles[:text]} px-4 py-3 rounded-lg text-sm", role: "alert"
    end
  end

  def render?
    @message.present?
  end
end
