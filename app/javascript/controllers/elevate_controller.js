import { Controller } from "@hotwired/stimulus"

// Shadows a sticky bar only while it is actually floating over content. The
// sentinel sits just past the bar's resting position: once it scrolls into
// view, the bar has landed and the shadow comes off.
export default class extends Controller {
  static targets = ["bar", "sentinel"]

  connect() {
    if (!this.hasBarTarget || !this.hasSentinelTarget) return

    this.observer = new IntersectionObserver(
      ([entry]) => this.barTarget.classList.toggle("is-elevated", !entry.isIntersecting),
      { root: this.element.closest("[data-scroll-root]"), threshold: 1 }
    )

    this.observer.observe(this.sentinelTarget)
  }

  disconnect() {
    this.observer?.disconnect()
  }
}
