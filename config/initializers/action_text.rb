ActiveSupport.on_load(:action_text_content) do
  default_tags = ActionText::ContentHelper.allowed_tags || ActionText::ContentHelper.sanitizer.class.allowed_tags
  ActionText::ContentHelper.allowed_tags = Set.new(default_tags) + %w[
    video audio source iframe
    table thead tbody tfoot tr th td
    pre code figure figcaption img picture
    span div hr br
  ]

  default_attributes = ActionText::ContentHelper.allowed_attributes || ActionText::ContentHelper.sanitizer.class.allowed_attributes
  ActionText::ContentHelper.allowed_attributes = Set.new(default_attributes) + %w[
    src href alt title width height
    controls autoplay loop muted playsinline preload poster type
    frameborder allow allowfullscreen
    class data-language loading decoding
  ]
end
