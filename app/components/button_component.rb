# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary: "bg-gray-900 text-white hover:bg-gray-700 border border-gray-900",
    secondary: "bg-white text-gray-700 hover:bg-gray-50 border border-gray-300",
    success: "bg-green-600 text-white hover:bg-green-700 border border-green-600",
    danger: "bg-red-600 text-white hover:bg-red-700 border border-red-600",
    ghost: "bg-transparent text-gray-500 hover:text-gray-700 border-0"
  }.freeze

  SIZES = {
    sm: "px-3 py-1.5 text-xs",
    md: "px-4 py-2 text-sm",
    lg: "px-5 py-2.5 text-sm"
  }.freeze

  def initialize(variant: :primary, size: :md, href: nil, method: nil, icon: nil, confirm: nil, type: "button", **options)
    @variant = variant
    @size = size
    @href = href
    @method = method
    @icon = icon
    @confirm = confirm
    @type = type
    @options = options
  end

  def call
    if @href
      link_button
    else
      tag_button
    end
  end

  private

  def base_classes
    "inline-flex items-center font-medium rounded-md cursor-pointer transition-colors #{VARIANTS[@variant]} #{SIZES[@size]} #{@options[:class]}"
  end

  def link_button
    link_to @href, class: base_classes, method: @method, data: confirm_data do
      button_content
    end
  end

  def tag_button
    content_tag :button, type: @type, class: base_classes, name: @options[:name], value: @options[:value], data: confirm_data do
      button_content
    end
  end

  def button_content
    safe_join([ icon_tag, content ].compact)
  end

  def icon_tag
    return nil unless @icon

    content_tag :span, @icon.html_safe, class: "mr-1.5"
  end

  def confirm_data
    @confirm ? { turbo_confirm: @confirm } : {}
  end
end
