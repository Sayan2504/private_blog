import { Controller } from "@hotwired/stimulus"

// Ticks a number up from zero, one integer at a time, the moment it scrolls
// into view — a small, one-time flourish for stat cards (currently just the
// About page's years of experience). The server always renders the real,
// final text first: this controller reads the number back out of its own
// textContent rather than a data attribute, so a template edit can't drift
// out of sync with what actually animates, and prefers-reduced-motion /
// no-JS both fall back to that static text untouched.
//
// Plain integer ticks rather than an eased tween on purpose: these numbers
// are small (single digits), so a curve that front-loads its motion reaches
// the target before it's readable as "counting" at all. A steady step per
// tick is the version that actually looks like counting up to settle.
export default class extends Controller {
  static values = { duration: { type: Number, default: 1000 } }

  connect() {
    const match = this.element.textContent.match(/\d+/)
    if (!match || window.matchMedia("(prefers-reduced-motion: reduce)").matches) return

    this.target = parseInt(match[0], 10)
    this.prefix = this.element.textContent.slice(0, match.index)
    this.suffix = this.element.textContent.slice(match.index + match[0].length)

    this.observer = new IntersectionObserver(([entry]) => {
      if (!entry.isIntersecting) return
      this.observer.disconnect()
      this.animate()
    }, { root: this.element.closest("[data-scroll-root]"), threshold: 0.6 })

    this.observer.observe(this.element)
  }

  disconnect() {
    this.observer?.disconnect()
    clearTimeout(this.timer)
    this.element.classList.remove("is-counting")
  }

  animate() {
    const stepMs = Math.max(this.durationValue / Math.max(this.target, 1), 90)
    let value = 0

    // Grown for the duration of the count (see .is-counting in
    // application.css) and released the instant it lands on the target —
    // the shrink-back-to-size is what reads as "settling."
    this.element.classList.add("is-counting")
    this.render(value)

    const tick = () => {
      value += 1
      this.render(value)

      if (value < this.target) {
        this.timer = setTimeout(tick, stepMs)
      } else {
        this.element.classList.remove("is-counting")
      }
    }

    this.timer = setTimeout(tick, stepMs)
  }

  render(value) {
    this.element.textContent = `${this.prefix}${value}${this.suffix}`
  }
}
