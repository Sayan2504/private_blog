import { Controller } from "@hotwired/stimulus"

// Lifts the header clusters off the page once content has scrolled beneath
// them. A one-pixel sentinel pinned to the top of the scroll region does the
// reporting, so this never runs work on the scroll event itself.
export default class extends Controller {
  static targets = ["bar", "sentinel"]

  connect() {
    if (!this.hasBarTarget || !this.hasSentinelTarget) return

    this.observer = new IntersectionObserver(
      ([entry]) => this.barTarget.classList.toggle("is-floating", !entry.isIntersecting),
      { root: this.element.querySelector("[data-scroll-root]"), threshold: 1 }
    )

    this.observer.observe(this.sentinelTarget)
  }

  disconnect() {
    this.observer?.disconnect()
  }
}
