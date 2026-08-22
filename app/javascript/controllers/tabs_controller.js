import { Controller } from "@hotwired/stimulus"

// A segmented control whose indicator slides between tabs.
//
// The tabs drive a turbo-frame, so the page around them is never re-rendered —
// which also means nothing arrives to show the new state. The pill has to move
// here instead, on click, ahead of the frame's response. The server still
// renders `aria-current` on the active tab, so a full page load (or a browser
// back) lands with the right tab lit and the indicator is placed to match.
export default class extends Controller {
  static targets = ["tab", "indicator"]

  connect() {
    // Until this class lands, the active link paints its own pill — the
    // no-JavaScript fallback, since the indicator's width is measured here.
    this.element.classList.add("is-ready")
    this.place(this.currentTab, { animate: false })

    this.reposition = () => this.place(this.currentTab, { animate: false })
    window.addEventListener("resize", this.reposition)
  }

  disconnect() {
    window.removeEventListener("resize", this.reposition)
  }

  select(event) {
    const tab = event.currentTarget

    // Re-requesting the list you are already looking at is a wasted round trip
    // and a pointless re-animation of the same cards.
    if (tab === this.currentTab) {
      event.preventDefault()
      return
    }

    this.tabTargets.forEach((other) => other.removeAttribute("aria-current"))
    tab.setAttribute("aria-current", "page")
    this.place(tab, { animate: true })

    // The address bar is updated by hand rather than with
    // data-turbo-action="advance". That attribute turns the frame navigation
    // into a page visit as well, and a page visit runs the root view
    // transition — which freezes a snapshot of the page over the top of the
    // list that is, at that exact moment, animating itself in. The result was
    // the whole-page lurch these tabs exist to avoid. replaceState keeps the
    // tab in the URL (reload and share still land on it) without proposing a
    // visit, and passing the existing state through leaves Turbo's own
    // restoration bookkeeping intact.
    history.replaceState(history.state, "", tab.href)
  }

  get currentTab() {
    return this.tabTargets.find((tab) => tab.getAttribute("aria-current") === "page") || this.tabTargets[0]
  }

  // The indicator is a sibling of the tabs inside a positioned track, so a tab's
  // own offset is exactly where the pill has to sit.
  place(tab, { animate }) {
    if (!tab || !this.hasIndicatorTarget) return

    const indicator = this.indicatorTarget

    // The first placement is a measurement, not a move: without this the pill
    // would slide in from the left edge every time the page loads.
    if (!animate) indicator.style.transition = "none"

    indicator.style.width = `${tab.offsetWidth}px`
    indicator.style.transform = `translateX(${tab.offsetLeft}px)`

    if (!animate) {
      void indicator.offsetWidth
      indicator.style.transition = ""
    }
  }
}
