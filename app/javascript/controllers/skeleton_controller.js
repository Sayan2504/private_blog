import { Controller } from "@hotwired/stimulus"

// Holds a structural placeholder in front of the article for a beat, then hands
// over to the real content.
//
// The article is already in the document — this is a deliberate, bounded pause,
// not a wait on anything. That is exactly why the swap is a single timer with
// no network or async dependency: there is no failure mode in which the content
// never arrives. `disconnect` clears it so a Turbo navigation mid-pause cannot
// fire the swap against a detached element.
export default class extends Controller {
  static values = { delay: { type: Number, default: 800 } }

  connect() {
    // Reduced motion gets the article immediately. A purely decorative wait is
    // precisely what that setting asks us to drop.
    const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches

    this.timer = setTimeout(() => {
      this.element.classList.add("is-loaded")
    }, reduced ? 0 : this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timer)
  }
}
