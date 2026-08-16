import { Controller } from "@hotwired/stimulus"

// Fallback only — the real duration is read back off each element.
const REVEAL_MS = 450

// Prose blocks reveal on a much tighter heel than page furniture.
const FAST_STAGGER = 30

// Reveals [data-reveal-item] elements as they enter the scroll pane, with a
// small stagger between items that land together. Each item is revealed once
// and then unobserved — nothing re-animates on the way back up.
//
// A grid marked [data-reveal-stack] gets a different entrance: its cards start
// piled on the first card's position and deal out into their own slots.
export default class extends Controller {
  static values = {
    stagger: { type: Number, default: 70 },
    maxStagger: { type: Number, default: 6 }
  }

  connect() {
    this.markProse()

    this.items = Array.from(this.element.querySelectorAll("[data-reveal-item]"))
    if (this.items.length === 0) return

    this.timers = new Set()

    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.items.forEach((item) => this.settle(item))
      return
    }

    this.stackCards()

    // Let the stacked state own a painted frame before anything can reveal:
    // the intersection callback otherwise fires in the same frame, and the
    // browser has no start value to animate the deal from. The cards are still
    // at opacity 0 here, so the pile itself is never visible.
    this.frame = requestAnimationFrame(() => {
      this.frame = requestAnimationFrame(() => this.observeItems())
    })
  }

  observeItems() {
    this.observer = new IntersectionObserver(this.reveal.bind(this), {
      // The page body never scrolls — the content pane does.
      root: this.element.closest("[data-scroll-root]"),
      rootMargin: "0px 0px -5% 0px",
      threshold: 0.1
    })

    this.items.forEach((item) => this.observer.observe(item))
  }

  disconnect() {
    cancelAnimationFrame(this.frame)
    this.observer?.disconnect()
    this.timers?.forEach((timer) => clearTimeout(timer))
  }

  // Article bodies are rendered HTML, so the blocks to reveal can only be
  // found at runtime. They get a tighter stagger than the rest of the page:
  // paragraphs arriving on a delay is the fastest way to make reading annoying.
  markProse() {
    this.element.querySelectorAll("[data-reveal-prose]").forEach((prose) => {
      // ActionText wraps the body in .trix-content, so the blocks worth
      // revealing are usually a level below the container.
      const scope = prose.querySelector(".trix-content") || prose

      Array.from(scope.children).forEach((block) => {
        block.setAttribute("data-reveal-item", "")
        block.dataset.revealFast = ""
      })
    })
  }

  // Offsets each card back onto the first card's position, so revealing it —
  // which clears the offset — deals it out to where it actually belongs.
  stackCards() {
    this.element.querySelectorAll("[data-reveal-stack]").forEach((grid) => {
      const cards = Array.from(grid.querySelectorAll(":scope > [data-reveal-item]"))
      if (cards.length < 2) return

      const origin = cards[0].getBoundingClientRect()

      const dealt = cards.slice(1)

      dealt.forEach((card, index) => {
        const box = card.getBoundingClientRect()
        const lean = index % 2 === 0 ? -1.2 : 1.2

        // Cards carry `transition-all` for their hover lift, which would
        // otherwise animate them *into* the pile. The stack has to be
        // established instantly — only the deal out of it should animate.
        card.style.transition = "none"
        card.dataset.revealDealt = ""
        card.style.transform = [
          `translate(${origin.left - box.left}px, ${origin.top - box.top}px)`,
          `scale(0.96)`,
          `rotate(${lean}deg)`
        ].join(" ")
      })

      // Commit the stacked position, then hand transitions back to CSS so the
      // deal itself animates.
      void grid.offsetHeight
      dealt.forEach((card) => (card.style.transition = ""))
    })
  }

  reveal(entries) {
    entries
      .filter((entry) => entry.isIntersecting)
      .forEach((entry, index) => {
        const item = entry.target
        const step = "revealFast" in item.dataset ? FAST_STAGGER : this.staggerValue
        const delay = Math.min(index, this.maxStaggerValue) * step

        item.style.transitionDelay = `${delay}ms`

        if ("revealDealt" in item.dataset) {
          item.classList.add("is-dealt")
          // Hand the transform back to CSS (`transform: none`) so the card
          // travels from the pile to its slot.
          item.style.transform = ""
        }

        item.classList.add("is-revealed")
        this.observer.unobserve(item)

        // Once an element has arrived, drop the marker so the reveal
        // transition stops shadowing whatever transition the element declares
        // for itself (card hover lifts, for one).
        const timer = setTimeout(() => this.settle(item), delay + this.durationOf(item) + 60)
        this.timers.add(timer)
      })
  }

  durationOf(item) {
    const declared = getComputedStyle(item)
      .transitionDuration.split(",")
      .map((value) => parseFloat(value) * 1000)

    return Math.max(...declared, REVEAL_MS)
  }

  settle(item) {
    item.style.transitionDelay = ""
    item.style.transform = ""
    item.classList.remove("is-dealt")
    delete item.dataset.revealDealt
    item.removeAttribute("data-reveal-item")
  }
}
