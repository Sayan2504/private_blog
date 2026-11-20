// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "trix"
import "@rails/actiontext"

if (window.Trix?.config?.textAttributes && !window.Trix.config.textAttributes.inlineCode) {
  window.Trix.config.textAttributes.inlineCode = {
    tagName: "code",
    inherent: true
  }
}

import "controllers"
