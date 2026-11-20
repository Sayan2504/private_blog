import { Controller } from "@hotwired/stimulus"

const TOKEN_PATTERN = new RegExp(
  [
    "(#[^\\n]*|\\/\\/[^\\n]*|\\/\\*[\\s\\S]*?\\*\\/)", // comments
    "('(?:\\\\.|[^'\\\\\\n])*'|\"(?:\\\\.|[^\"\\\\\\n])*\"|`(?:\\\\.|[^`\\\\])*`)", // strings
    "(?<![\\w:]):[a-zA-Z_]\\w*[?!]?", // ruby symbols
    "\\b([A-Z][A-Za-z0-9_]*)\\b", // constants / classes
    "\\b(def|end|class|module|do|if|elsif|else|unless|case|when|while|until|for|in|return|yield|raise|begin|rescue|ensure|require|require_relative|include|extend|attr_reader|attr_writer|attr_accessor|private|protected|public|self|super|true|false|nil|null|undefined|const|let|var|function|async|await|import|export|from|default|new|try|catch|finally|throw|describe|context|it|expect|let!|subject|before|after|SELECT|INSERT|UPDATE|DELETE|FROM|WHERE|JOIN|AND|OR|LIMIT|ORDER|BY)\\b", // keywords
    "\\b(\\d+(?:\\.\\d+)?)\\b" // numbers
  ].join("|"),
  "g"
)

// Wraps every word of an article body so it can be scrubbed from dim to clear
// against scroll position (see the .word rules in application.css), and
// enhances <pre> code snippets with syntax highlighting + copy button.
export default class extends Controller {
  connect() {
    this.enhanceCodeBlocks()

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

  enhanceCodeBlocks() {
    const pres = Array.from(this.element.querySelectorAll("pre"))

    pres.forEach((pre) => {
      if (pre.closest(".code-block-wrapper")) return

      const source = pre.querySelector("code") || pre
      source.querySelectorAll("br").forEach((br) => br.replaceWith(document.createTextNode("\n")))

      const rawCode = source.textContent.replace(/\r\n?/g, "\n").replace(/\n+$/, "")
      if (rawCode.trim() === "") return

      const language = this.detectLanguage(pre, source, rawCode)

      const wrapper = document.createElement("div")
      wrapper.className = "code-block-wrapper"

      const header = document.createElement("div")
      header.className = "code-block-header"

      const label = document.createElement("span")
      label.textContent = language

      const copyBtn = document.createElement("button")
      copyBtn.type = "button"
      copyBtn.className = "code-copy-btn"
      copyBtn.textContent = "Copy"
      copyBtn.addEventListener("click", async () => {
        try {
          await navigator.clipboard?.writeText(rawCode)
          copyBtn.textContent = "Copied!"
          setTimeout(() => {
            copyBtn.textContent = "Copy"
          }, 1800)
        } catch {
          copyBtn.textContent = "Failed"
          setTimeout(() => {
            copyBtn.textContent = "Copy"
          }, 1800)
        }
      })

      header.append(label, copyBtn)

      const codeEl = document.createElement("code")
      codeEl.innerHTML = this.highlightCode(rawCode)

      pre.innerHTML = ""
      pre.appendChild(codeEl)

      pre.parentNode.insertBefore(wrapper, pre)
      wrapper.append(header, pre)
    })
  }

  detectLanguage(pre, source, code) {
    const explicit =
      pre.dataset.language ||
      source.dataset.language ||
      pre.className.match(/language-([\w-]+)/)?.[1] ||
      source.className.match(/language-([\w-]+)/)?.[1]

    if (explicit) return explicit.toUpperCase()
    if (/^\s*(SELECT|INSERT|UPDATE|DELETE|CREATE|ALTER)\b/im.test(code)) return "SQL"
    if (/\b(RSpec|describe|context|def|end|module|attr_reader|require)\b/.test(code)) return "Ruby"
    if (/\b(const|let|function|async|await|import|export)\b|=>|console\.log/.test(code)) return "JavaScript"
    if (/^(\$\s|curl\s|bundle\s|bin\/|rails\s|npm\s|docker\s)/m.test(code)) return "Bash"
    return "Code"
  }

  highlightCode(code) {
    let result = ""
    let lastIndex = 0
    TOKEN_PATTERN.lastIndex = 0

    for (const match of code.matchAll(TOKEN_PATTERN)) {
      const idx = match.index ?? 0
      if (idx > lastIndex) {
        result += this.escapeHtml(code.slice(lastIndex, idx))
      }

      const [full, comment, str, sym, constant, kw, num] = match
      let cls = ""
      if (comment) cls = "tok-com"
      else if (str) cls = "tok-str"
      else if (sym) cls = "tok-sym"
      else if (constant) cls = "tok-const"
      else if (kw) cls = "tok-kw"
      else if (num) cls = "tok-num"

      result += cls ? `<span class="${cls}">${this.escapeHtml(full)}</span>` : this.escapeHtml(full)
      lastIndex = idx + full.length
    }

    if (lastIndex < code.length) {
      result += this.escapeHtml(code.slice(lastIndex))
    }

    return result
  }

  escapeHtml(text) {
    return text
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
  }

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
        if (node.parentElement.closest("pre, code, action-text-attachment, .code-block-header")) {
          return NodeFilter.FILTER_REJECT
        }
        return NodeFilter.FILTER_ACCEPT
      }
    })

    const nodes = []
    while (walker.nextNode()) nodes.push(walker.currentNode)

    nodes.forEach((node) => {
      const fragment = document.createDocumentFragment()

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
