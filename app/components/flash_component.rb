# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  VARIANTS = {
    notice: { bg: "bg-green-50 dark:bg-green-900/20", border: "border-green-200 dark:border-green-800", text: "text-green-800 dark:text-green-200" },
    alert: { bg: "bg-red-50 dark:bg-red-900/20", border: "border-red-200 dark:border-red-800", text: "text-red-800 dark:text-red-200" }
  }.freeze

  def initialize(type:, message:)
    @type = type.to_sym
    @message = message
  end

  def call
    styles = VARIANTS[@type] || VARIANTS[:notice]

    content_tag :div,
      class: "motion-flash mx-auto mt-4 w-full max-w-6xl px-4 sm:px-6 lg:px-8",
      data: { controller: "flash", action: "click->flash#dismiss" } do
      content_tag :div, @message, class: "#{styles[:bg]} border #{styles[:border]} #{styles[:text]} px-4 py-3 rounded-lg text-sm cursor-pointer", role: "alert"
    end
  end

  def render?
    @message.present?
  end
end
