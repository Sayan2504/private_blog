import { Controller } from "@hotwired/stimulus"

// The md breakpoint, where the drawer stops being a drawer and becomes a
// static column. Everything modal about it is scoped to below this.
const DESKTOP = "(min-width: 768px)"

// Below md the sidebar is a modal drawer over the page; from md up it is just
// a column that is always there. The distinction matters for more than the
// transform: while it is a drawer it has to behave like a dialog — reachable
// only while open, dismissible with Escape, and returning focus to the control
// that summoned it.
//
// Before this, the panel was only ever slid off-canvas with a transform, which
// moves it out of sight but leaves it in the tab order: on a phone, tabbing
// from the header walked through nav links that were nowhere on screen.
// `inert` is what actually takes it out of reach, and pointing it at the main
// column instead while the drawer is open is what keeps Tab inside the drawer
// without hand-rolling a focus cycle.
export default class extends Controller {
  static targets = ["panel", "overlay", "trigger", "close", "main"]

  connect() {
    this.isOpen = false
    this.desktop = window.matchMedia(DESKTOP)

    // A resize across the breakpoint has to reset the modal bookkeeping, or a
    // drawer left open on a phone stays "open" after the layout has already
    // turned it back into a plain column.
    this.onBreakpoint = () => {
      if (this.desktop.matches) this.reset()
      this.syncInert()
    }

    this.desktop.addEventListener("change", this.onBreakpoint)
    this.syncInert()
  }

  disconnect() {
    this.desktop?.removeEventListener("change", this.onBreakpoint)
  }

  open() {
    if (this.isOpen || this.desktop.matches) return

    this.isOpen = true
    this.panelTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("opacity-0", "pointer-events-none")
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded", "true")
    this.syncInert()

    // Focus has to move into the drawer, or Escape and Tab have nothing to act
    // on and a keyboard user has opened something they cannot reach.
    if (this.hasCloseTarget) this.closeTarget.focus()
  }

  // Closing on the user's own initiative — the close button, Escape, or the
  // backdrop. Focus goes back to the hamburger that opened it, so the tab
  // sequence resumes where it left off instead of restarting at the document.
  dismiss() {
    if (!this.isOpen) return

    this.close()
    if (this.hasTriggerTarget) this.triggerTarget.focus()
  }

  // Closing as a side effect of something else — currently a Turbo visit,
  // where focus belongs to the page being navigated to, not to the control
  // that is about to be replaced.
  close() {
    this.reset()
    this.syncInert()
  }

  reset() {
    this.isOpen = false
    this.panelTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("opacity-0", "pointer-events-none")
    if (this.hasTriggerTarget) this.triggerTarget.setAttribute("aria-expanded", "false")
  }

  // Only one of the two is ever inert, and only below md: the panel while it
  // is off-canvas, the rest of the page while it is covering it.
  syncInert() {
    const drawer = !this.desktop.matches

    this.panelTarget.inert = drawer && !this.isOpen
    if (this.hasMainTarget) this.mainTarget.inert = drawer && this.isOpen
  }
}
