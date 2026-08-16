import { Controller } from "@hotwired/stimulus"

// Wraps every word of an article body so it can be scrubbed from dim to clear
// against scroll position (see the .word rules in application.css).
//
// The dimming is only ever switched on when the browser can actually run the
// scroll-driven animation. Anything else — no support, reduced motion — leaves
// the text at full contrast rather than stranding it at 28% opacity.
export default class extends Controller {
  connect() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return
    if (!CSS.supports("animation-timeline", "view()")) return

    this.wrapWords()
    this.element.classList.add("is-scrubbing")
    this.limitLiveBlocks()
  }

  disconnect() {
    this.observer?.disconnect()
    this.element.classList.remove("is-scrubbing")
  }

  // A live view() timeline per word costs real frame time, and a long article
  // has well over a thousand. Only blocks within a viewport of the reading
  // band get animated; everything above is pinned clear, everything below
  // stays at its dimmed resting opacity.
  limitLiveBlocks() {
    const scope = this.element.querySelector(".trix-content") || this.element
    const blocks = Array.from(scope.children)

    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          const block = entry.target

          if (entry.isIntersecting) {
            block.classList.add("is-live")
            block.classList.remove("is-read")
            return
          }

          block.classList.remove("is-live")
          const passed = entry.boundingClientRect.top < (entry.rootBounds?.top ?? 0)
          block.classList.toggle("is-read", passed)
        })
      },
      { root: this.element.closest("[data-scroll-root]"), rootMargin: "50% 0px 50% 0px" }
    )

    blocks.forEach((block) => this.observer.observe(block))
  }

  wrapWords() {
    const walker = document.createTreeWalker(this.element, NodeFilter.SHOW_TEXT, {
      acceptNode(node) {
        if (node.nodeValue.trim() === "") return NodeFilter.FILTER_REJECT
        // Code keeps its own spacing and colouring — leave it alone.
        if (node.parentElement.closest("pre, code, action-text-attachment")) {
          return NodeFilter.FILTER_REJECT
        }
        return NodeFilter.FILTER_ACCEPT
      }
    })

    const nodes = []
    while (walker.nextNode()) nodes.push(walker.currentNode)

    nodes.forEach((node) => {
      const fragment = document.createDocumentFragment()

      // Splitting on the separator keeps the whitespace as its own chunk, so
      // line breaking behaves exactly as it did before wrapping.
      node.nodeValue.split(/(\s+)/).forEach((chunk) => {
        if (chunk === "") return

        if (/^\s+$/.test(chunk)) {
          fragment.appendChild(document.createTextNode(chunk))
          return
        }

        const word = document.createElement("span")
        word.className = "word"
        word.textContent = chunk
        fragment.appendChild(word)
      })

      node.parentNode.replaceChild(fragment, node)
    })
  }
}
