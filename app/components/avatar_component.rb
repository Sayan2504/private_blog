# frozen_string_literal: true

class AvatarComponent < ViewComponent::Base
  SIZES = {
    sm: "w-6 h-6 text-xs",
    md: "w-8 h-8 text-sm",
    lg: "w-10 h-10 text-sm"
  }.freeze

  def initialize(name:, size: :sm)
    @name = name
    @size = size
  end

  def call
    content_tag :div, class: "#{SIZES[@size]} rounded-full bg-gradient-to-br from-purple-500 to-blue-500 flex items-center justify-center" do
      content_tag :span, initial, class: "text-white font-medium"
    end
  end

  private

  def initial
    @name.to_s.first&.upcase || "A"
  end
end
