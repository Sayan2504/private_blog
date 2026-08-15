import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "overlay"]

  // The body never scrolls (app shell is h-screen/overflow-hidden), so the
  // drawer only has to toggle the panel and its backdrop — touching body's
  // overflow here would strip the class the layout depends on.
  open() {
    this.panelTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.panelTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")
  }
}
