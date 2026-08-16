import { Controller } from "@hotwired/stimulus"

// Fallback for the reading progress bar. Browsers with scroll-driven
// animations run it entirely in CSS (see .reading-progress) and this does
// nothing; everywhere else it tracks the content pane's scroll position.
export default class extends Controller {
  connect() {
    if (CSS.supports("animation-timeline", "scroll()")) return

    this.pane = this.element.closest("[data-scroll-root]")
    if (!this.pane) return

    this.update = this.update.bind(this)
    this.pane.addEventListener("scroll", this.update, { passive: true })
    window.addEventListener("resize", this.update)
    this.update()
  }

  disconnect() {
    this.pane?.removeEventListener("scroll", this.update)
    window.removeEventListener("resize", this.update)
    cancelAnimationFrame(this.frame)
  }

  update() {
    cancelAnimationFrame(this.frame)

    this.frame = requestAnimationFrame(() => {
      const travel = this.pane.scrollHeight - this.pane.clientHeight
      const ratio = travel > 0 ? this.pane.scrollTop / travel : 0
      this.element.style.setProperty("--reading-progress", Math.min(ratio, 1))
    })
  }
}
