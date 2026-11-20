# frozen_string_literal: true

class ButtonComponent < ViewComponent::Base
  VARIANTS = {
    primary: "bg-gray-900 text-white hover:bg-gray-700 border border-gray-900 dark:bg-gray-100 dark:text-gray-900 dark:hover:bg-gray-300 dark:border-gray-100",
    secondary: "bg-white text-gray-700 hover:bg-gray-50 border border-gray-300 dark:bg-gray-800 dark:text-gray-200 dark:hover:bg-gray-700 dark:border-gray-600",
    success: "bg-green-600 text-white hover:bg-green-700 border border-green-600 dark:bg-green-500 dark:hover:bg-green-600 dark:border-green-500",
    danger: "bg-red-600 text-white hover:bg-red-700 border border-red-600 dark:bg-red-500 dark:hover:bg-red-600 dark:border-red-500",
    ghost: "bg-transparent text-gray-500 hover:text-gray-700 border-0 dark:text-gray-400 dark:hover:text-gray-200",
    ghost_danger: "bg-transparent text-red-500 hover:text-red-700 border-0 dark:text-red-400 dark:hover:text-red-300"
  }.freeze

  # A fixed height per tier — not just padding — is what actually guarantees
  # every button of a given size renders at the same pixel height regardless
  # of resolution. Padding-only sizing looked fine until a bordered variant
  # (primary, secondary, success, danger) sat next to a borderless one
  # (ghost): border-box still adds the 1px border on top of the padding, so
  # the borderless button quietly rendered 2px shorter than its neighbour.
  # An explicit h-* absorbs the border inside the box instead.
  SIZES = {
    sm: "h-8 px-3 text-xs",
    md: "h-10 px-4 text-sm",
    lg: "h-11 px-5 text-sm"
  }.freeze

  def initialize(variant: :primary, size: :md, href: nil, method: nil, icon: nil, confirm: nil,
                 confirm_title: nil, confirm_label: nil, submits_with: nil, type: "button", **options)
    @variant = variant
    @size = size
    @href = href
    @method = method
    @icon = icon
    @confirm = confirm
    @confirm_title = confirm_title
    @confirm_label = confirm_label
    @submits_with = submits_with
    @type = type
    @options = options
  end

  def call
    if @href && @method.present?
      button_to_link
    elsif @href
      link_button
    else
      tag_button
    end
  end

  private

  # `disabled:` covers more than a permanently-off button: Turbo disables the
  # submitter for the length of a form submission, so this is also what a
  # button in flight looks like. Without it a submitting button was
  # indistinguishable from an idle one, and the only feedback that anything
  # had happened was the page eventually changing.
  DISABLED_CLASSES = "disabled:cursor-not-allowed disabled:opacity-60 disabled:active:scale-100"

  def base_classes
    [
      "inline-flex shrink-0 items-center justify-center gap-1.5 font-medium rounded-md cursor-pointer",
      "transition-[color,background-color,border-color,box-shadow,scale] duration-300 ease-soft active:scale-[0.97]",
      DISABLED_CLASSES,
      VARIANTS[@variant],
      SIZES[@size],
      @options[:class]
    ].compact.join(" ")
  end

  def link_button
    link_to @href, class: base_classes, method: @method, data: button_data, **html_options do
      button_content
    end
  end

  def button_to_link
    button_to @href, method: @method, class: base_classes, data: button_data, form: { class: "inline-flex" }, **html_options do
      button_content
    end
  end

  def tag_button
    content_tag :button, type: @type, class: base_classes, name: @options[:name], value: @options[:value], data: button_data, **html_options do
      button_content
    end
  end

  def html_options
    @options.except(:class, :name, :value, :data)
  end

  def button_content
    safe_join([ icon_tag, content ].compact)
  end

  def icon_tag
    return nil unless @icon

    content_tag :span, @icon.html_safe, class: "inline-flex"
  end

  # The confirmation dialog (ConfirmDialogComponent) reads these off whichever
  # element raised it. Only `turbo_confirm` is Turbo's own; the rest are ours,
  # and each is omitted when unset so the dialog falls back to its defaults
  # rather than being handed an empty string.
  def confirm_data
    merged = (@options[:data] || {}).dup
    return merged unless @confirm

    merged[:turbo_confirm] = @confirm
    merged[:turbo_confirm_title] = @confirm_title if @confirm_title
    merged[:turbo_confirm_label] = @confirm_label if @confirm_label

    # Intent is not restated at the call site: a button already says whether it
    # is destructive through its variant, and the dialog should agree with the
    # button that opened it.
    merged[:turbo_confirm_variant] = destructive? ? "danger" : "primary"
    merged
  end

  # Turbo swaps the label for this while the form is in flight and disables the
  # button, so a submit can neither be fired twice nor look like it was
  # ignored. Merged alongside the confirm keys because both live on `data`.
  def button_data
    data = confirm_data
    data[:turbo_submits_with] = @submits_with if @submits_with
    data
  end

  def destructive?
    %i[ danger ghost_danger ].include?(@variant)
  end
end
