import { Controller } from "@hotwired/stimulus"

// Dismisses a flash message after a beat, or on click, collapsing it out
// rather than letting it vanish.
export default class extends Controller {
  static values = {
    delay: { type: Number, default: 5000 },
    // Errors opt out: a message you have to read is not one to put on a
    // five-second timer. The component decides per variant.
    autoDismiss: { type: Boolean, default: true }
  }

  connect() {
    if (!this.autoDismissValue) return

    this.timer = setTimeout(() => this.dismiss(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  dismiss() {
    clearTimeout(this.timer)
    if (this.element.classList.contains("is-dismissed")) return

    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.element.remove()
      return
    }

    // Height has to be a concrete value for the collapse to interpolate.
    this.element.style.height = `${this.element.offsetHeight}px`

    requestAnimationFrame(() => {
      this.element.classList.add("is-dismissed")
      this.element.addEventListener("transitionend", () => this.element.remove(), {
        once: true
      })
    })
  }
}
