import { Controller } from "@hotwired/stimulus"

const EMOJI_GROUPS = [
  {
    label: "Smileys",
    items: [
      { char: "😀", name: "smile grin happy" },
      { char: "😄", name: "laugh joy happy" },
      { char: "😊", name: "blush warm smile" },
      { char: "🥳", name: "party celebrate" },
      { char: "🤔", name: "thinking hmm" },
      { char: "😎", name: "cool sunglasses" },
      { char: "🤯", name: "mind blown" },
      { char: "😅", name: "sweat relief" }
    ]
  },
  {
    label: "Coding & Tech",
    items: [
      { char: "💻", name: "laptop code computer" },
      { char: "🚀", name: "rocket launch ship" },
      { char: "🔥", name: "fire hot streak" },
      { char: "🐛", name: "bug debug fix" },
      { char: "💎", name: "ruby gem rails" },
      { char: "⚡", name: "zap fast lightning" },
      { char: "🔐", name: "lock secure auth" },
      { char: "🧠", name: "brain architecture smart" }
    ]
  },
  {
    label: "Gestures & Reactions",
    items: [
      { char: "👍", name: "thumbsup approve yes" },
      { char: "👏", name: "clap applaud" },
      { char: "🙌", name: "raised hands hooray" },
      { char: "❤️", name: "heart love" },
      { char: "🎉", name: "tada celebrate party" },
      { char: "✨", name: "sparkles magic shine" },
      { char: "💡", name: "bulb idea tip" },
      { char: "💯", name: "100 hundred perfect" }
    ]
  },
  {
    label: "Symbols & Objects",
    items: [
      { char: "✅", name: "check done pass" },
      { char: "⚠️", name: "warning alert caution" },
      { char: "⭐", name: "star favorite" },
      { char: "🔑", name: "key token access" },
      { char: "☕", name: "coffee break" },
      { char: "📚", name: "books docs read" },
      { char: "👀", name: "eyes look review" },
      { char: "🧩", name: "puzzle module pattern" }
    ]
  }
]

const SHORTCODES = {
  ":rocket:": "🚀",
  ":fire:": "🔥",
  ":heart:": "❤️",
  ":tada:": "🎉",
  ":sparkles:": "✨",
  ":thumbsup:": "👍",
  ":check:": "✅",
  ":bulb:": "💡",
  ":warning:": "⚠️",
  ":bug:": "🐛",
  ":ruby:": "💎",
  ":laptop:": "💻",
  ":smile:": "😀",
  ":100:": "💯",
  ":star:": "⭐",
  ":clap:": "👏",
  ":eyes:": "👀",
  ":brain:": "🧠",
  ":lock:": "🔐",
  ":key:": "🔑",
  ":zap:": "⚡",
  ":coffee:": "☕"
}

const SHORTCODE_REGEX = new RegExp(`(${Object.keys(SHORTCODES).map((k) => k.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")).join("|")})$`)

export default class extends Controller {
  static targets = ["textarea", "emojiPopover"]

  connect() {
    this.isExpanding = false
    this.ensureInlineCodeConfig()

    this.trixEditor = this.element.querySelector("trix-editor")
    if (this.trixEditor) {
      this.onBeforeInitialize = () => this.ensureInlineCodeConfig()
      this.onTrixInitialize = () => this.setupTrixToolbar()
      this.onTrixChange = () => this.handleTrixShortcodes()
      this.onTrixKeydown = (e) => {
        if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "e") {
          e.preventDefault()
          this.trixEditor.editor?.recordUndoEntry("Inline code")
          if (this.trixEditor.editor?.attributeIsActive("inlineCode")) {
            this.trixEditor.editor.deactivateAttribute("inlineCode")
          } else {
            this.trixEditor.editor?.activateAttribute("inlineCode")
          }
        }
      }

      this.trixEditor.addEventListener("trix-before-initialize", this.onBeforeInitialize)
      this.trixEditor.addEventListener("trix-initialize", this.onTrixInitialize)
      this.trixEditor.addEventListener("trix-change", this.onTrixChange)
      this.trixEditor.addEventListener("keydown", this.onTrixKeydown)

      if (this.trixEditor.editor) {
        this.setupTrixToolbar()
      }
    }

    this.onOutsideClick = (e) => {
      if (!this.element.contains(e.target)) {
        this.closePopovers()
      }
    }
    document.addEventListener("click", this.onOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this.onOutsideClick)
    if (this.trixEditor) {
      this.trixEditor.removeEventListener("trix-before-initialize", this.onBeforeInitialize)
      this.trixEditor.removeEventListener("trix-initialize", this.onTrixInitialize)
      this.trixEditor.removeEventListener("trix-change", this.onTrixChange)
      this.trixEditor.removeEventListener("keydown", this.onTrixKeydown)
    }
  }

  ensureInlineCodeConfig() {
    if (window.Trix?.config?.textAttributes && !window.Trix.config.textAttributes.inlineCode) {
      window.Trix.config.textAttributes.inlineCode = {
        tagName: "code",
        inherent: true
      }
    }
  }

  setupTrixToolbar() {
    const toolbar = this.trixEditor?.toolbarElement
    if (!toolbar || toolbar.dataset.richEnhanced === "true") return
    toolbar.dataset.richEnhanced = "true"

    const blockCodeBtn = toolbar.querySelector('[data-trix-attribute="code"]')
    if (blockCodeBtn) {
      blockCodeBtn.title = "Code snippet block"
    }

    const textTools = toolbar.querySelector(".trix-button-group--text-tools")
    if (textTools && !textTools.querySelector('[data-trix-attribute="inlineCode"]')) {
      const inlineBtn = document.createElement("button")
      inlineBtn.type = "button"
      inlineBtn.className = "trix-button font-mono text-[11px]"
      inlineBtn.dataset.trixAttribute = "inlineCode"
      inlineBtn.title = "Inline code (Ctrl+E)"
      inlineBtn.setAttribute("aria-label", "Inline code")
      inlineBtn.tabIndex = -1
      inlineBtn.textContent = "</>"
      textTools.appendChild(inlineBtn)
    }

    const row = toolbar.querySelector(".trix-button-row")
    if (row) {
      const group = document.createElement("span")
      group.className = "trix-button-group"

      const mediaBtn = document.createElement("button")
      mediaBtn.type = "button"
      mediaBtn.className = "trix-button"
      mediaBtn.title = "Embed image, video, or YouTube/Vimeo URL"
      mediaBtn.setAttribute("aria-label", "Embed image or video URL")
      mediaBtn.tabIndex = -1
      mediaBtn.textContent = "🎬"
      mediaBtn.addEventListener("click", (e) => {
        e.preventDefault()
        this.toggleMediaPopover()
      })

      const emojiBtn = document.createElement("button")
      emojiBtn.type = "button"
      emojiBtn.className = "trix-button"
      emojiBtn.title = "Insert emoji"
      emojiBtn.setAttribute("aria-label", "Insert emoji")
      emojiBtn.tabIndex = -1
      emojiBtn.textContent = "😀"
      emojiBtn.addEventListener("click", (e) => {
        e.preventDefault()
        this.toggleTrixEmojiPopover()
      })

      group.append(mediaBtn, emojiBtn)

      const spacer = row.querySelector(".trix-button-group-spacer")
      if (spacer) {
        row.insertBefore(group, spacer)
      } else {
        row.appendChild(group)
      }
    }

    this.buildTrixPopovers(toolbar)
  }

  buildTrixPopovers(toolbar) {
    let container = toolbar.querySelector(".trix-dialogs")
    if (!container) {
      container = document.createElement("div")
      container.className = "trix-dialogs"
      toolbar.appendChild(container)
    }

    // Media embed popover
    this.mediaPopover = document.createElement("div")
    this.mediaPopover.className =
      "hidden mt-2 rounded-2xl border border-gray-200 bg-white p-3.5 shadow-xl dark:border-gray-700 dark:bg-gray-900"
    this.mediaPopover.innerHTML = `
      <div class="flex flex-col gap-2 sm:flex-row sm:items-center">
        <input type="url" data-role="media-url" placeholder="Paste image, MP4/WebM video, YouTube, or Vimeo URL..."
          class="flex-1 rounded-xl border border-gray-200 bg-white px-3 py-1.5 text-xs text-gray-900 placeholder-gray-400 focus:outline-none dark:border-gray-700 dark:bg-gray-800 dark:text-gray-100" />
        <select data-role="media-type" class="rounded-xl border border-gray-200 bg-white px-2.5 py-1.5 text-xs text-gray-800 dark:border-gray-700 dark:bg-gray-800 dark:text-gray-100">
          <option value="auto">Auto-detect</option>
          <option value="image">Image</option>
          <option value="video">Video</option>
        </select>
        <div class="flex items-center gap-1.5">
          <button type="button" data-role="media-insert"
            class="rounded-xl bg-gray-900 px-3 py-1.5 text-xs font-medium text-white hover:bg-gray-700 dark:bg-gray-100 dark:text-gray-900">
            Insert
          </button>
          <button type="button" data-role="media-cancel"
            class="rounded-xl px-2.5 py-1.5 text-xs text-gray-500 hover:bg-gray-100 dark:text-gray-400 dark:hover:bg-gray-800">
            Cancel
          </button>
        </div>
      </div>
      <p class="mt-1.5 text-[11px] text-gray-400 dark:text-gray-500">Tip: You can also drag & drop or use the paperclip button to upload local images and videos.</p>
    `
    this.mediaPopover.querySelector('[data-role="media-insert"]').addEventListener("click", () => this.insertMediaFromPopover())
    this.mediaPopover.querySelector('[data-role="media-cancel"]').addEventListener("click", () => this.closePopovers())
    this.mediaPopover.querySelector('[data-role="media-url"]').addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault()
        this.insertMediaFromPopover()
      } else if (e.key === "Escape") {
        this.closePopovers()
      }
    })

    // Emoji picker popover
    this.trixEmojiPopover = this.createEmojiPickerElement((char) => {
      this.insertTextIntoTrix(char)
      this.closePopovers()
    })

    container.append(this.mediaPopover, this.trixEmojiPopover)
  }

  createEmojiPickerElement(onSelect) {
    const wrap = document.createElement("div")
    wrap.className =
      "hidden mt-2 max-w-md rounded-2xl border border-gray-200 bg-white p-3 shadow-xl dark:border-gray-700 dark:bg-gray-900"

    const search = document.createElement("input")
    search.type = "search"
    search.placeholder = "Filter emojis (e.g. rocket, ruby, fire)..."
    search.className =
      "mb-2.5 w-full rounded-xl border border-gray-200 bg-gray-50 px-3 py-1.5 text-xs text-gray-900 placeholder-gray-400 focus:outline-none dark:border-gray-700 dark:bg-gray-800 dark:text-gray-100"

    const gridHost = document.createElement("div")
    gridHost.className = "max-h-56 space-y-2.5 overflow-y-auto pr-1"

    const renderGroups = (query = "") => {
      const q = query.trim().toLowerCase()
      gridHost.innerHTML = ""

      EMOJI_GROUPS.forEach((group) => {
        const filtered = q
          ? group.items.filter((i) => i.name.includes(q) || i.char.includes(q))
          : group.items

        if (filtered.length === 0) return

        const section = document.createElement("div")
        const title = document.createElement("p")
        title.className = "mb-1 text-[10px] font-semibold uppercase tracking-[0.14em] text-gray-400 dark:text-gray-500"
        title.textContent = group.label

        const grid = document.createElement("div")
        grid.className = "grid grid-cols-8 gap-1"

        filtered.forEach((item) => {
          const btn = document.createElement("button")
          btn.type = "button"
          btn.title = item.name
          btn.textContent = item.char
          btn.className =
            "flex h-8 w-8 items-center justify-center rounded-lg text-lg transition hover:scale-110 hover:bg-gray-100 dark:hover:bg-gray-800"
          btn.addEventListener("click", (e) => {
            e.preventDefault()
            onSelect(item.char)
          })
          grid.appendChild(btn)
        })

        section.append(title, grid)
        gridHost.appendChild(section)
      })
    }

    search.addEventListener("input", () => renderGroups(search.value))
    renderGroups()

    wrap.append(search, gridHost)
    return wrap
  }

  toggleMediaPopover() {
    if (!this.mediaPopover) return
    const wasHidden = this.mediaPopover.classList.contains("hidden")
    this.closePopovers()
    if (wasHidden) {
      this.mediaPopover.classList.remove("hidden")
      this.mediaPopover.querySelector('[data-role="media-url"]')?.focus()
    }
  }

  toggleTrixEmojiPopover() {
    if (!this.trixEmojiPopover) return
    const wasHidden = this.trixEmojiPopover.classList.contains("hidden")
    this.closePopovers()
    if (wasHidden) {
      this.trixEmojiPopover.classList.remove("hidden")
      this.trixEmojiPopover.querySelector('input[type="search"]')?.focus()
    }
  }

  toggleEmoji(event) {
    event.preventDefault()
    if (!this.hasEmojiPopoverTarget) return
    if (this.emojiPopoverTarget.children.length === 0) {
      const picker = this.createEmojiPickerElement((char) => {
        this.insertTextIntoTextarea(char)
        this.closePopovers()
      })
      picker.classList.remove("hidden", "mt-2")
      this.emojiPopoverTarget.appendChild(picker)
    }
    this.emojiPopoverTarget.classList.toggle("hidden")
  }

  insertEmoji(event) {
    event.preventDefault()
    const char = event.currentTarget.dataset.emoji
    if (!char) return
    if (this.hasTextareaTarget) {
      this.insertTextIntoTextarea(char)
    } else if (this.trixEditor) {
      this.insertTextIntoTrix(char)
    }
  }

  closePopovers() {
    this.mediaPopover?.classList.add("hidden")
    this.trixEmojiPopover?.classList.add("hidden")
    if (this.hasEmojiPopoverTarget) {
      this.emojiPopoverTarget.classList.add("hidden")
    }
  }

  insertMediaFromPopover() {
    const urlInput = this.mediaPopover?.querySelector('[data-role="media-url"]')
    const typeSelect = this.mediaPopover?.querySelector('[data-role="media-type"]')
    const rawUrl = urlInput?.value?.trim() || ""
    const mode = typeSelect?.value || "auto"

    if (!rawUrl || !/^(https?:\/\/|\/)/i.test(rawUrl)) return

    const html = this.buildMediaHtml(rawUrl, mode)
    if (!html || !this.trixEditor?.editor || !window.Trix) return

    const attachment = new window.Trix.Attachment({
      content: html,
      contentType: "text/html"
    })
    this.trixEditor.editor.insertAttachment(attachment)
    this.trixEditor.focus()
    urlInput.value = ""
    this.closePopovers()
  }

  buildMediaHtml(url, mode) {
    const safeUrl = url.replace(/"/g, "&quot;").replace(/</g, "&lt;").replace(/>/g, "&gt;")

    if (mode !== "image") {
      const ytMatch = url.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/|youtube\.com\/embed\/)([A-Za-z0-9_-]{6,})/)
      if (ytMatch) {
        return `<iframe src="https://www.youtube.com/embed/${ytMatch[1]}" title="YouTube video" allowfullscreen></iframe>`
      }

      const vimeoMatch = url.match(/vimeo\.com\/(?:video\/)?(\d+)/)
      if (vimeoMatch) {
        return `<iframe src="https://player.vimeo.com/video/${vimeoMatch[1]}" title="Vimeo video" allowfullscreen></iframe>`
      }

      if (mode === "video" || /\.(mp4|webm|ogg|mov|m4v)(\?.*)?$/i.test(url)) {
        return `<video controls playsinline preload="metadata" src="${safeUrl}"></video>`
      }
    }

    return `<img src="${safeUrl}" alt="Embedded image" loading="lazy" />`
  }

  insertTextIntoTrix(text) {
    const editor = this.trixEditor?.editor
    if (!editor) return
    editor.insertString(text)
    this.trixEditor.focus()
  }

  insertTextIntoTextarea(text) {
    if (!this.hasTextareaTarget) return
    const ta = this.textareaTarget
    const start = ta.selectionStart ?? ta.value.length
    const end = ta.selectionEnd ?? ta.value.length
    ta.setRangeText(text, start, end, "end")
    ta.focus()
    ta.dispatchEvent(new Event("input", { bubbles: true }))
  }

  handleTrixShortcodes() {
    if (this.isExpanding || !this.trixEditor?.editor) return
    const editor = this.trixEditor.editor
    const doc = editor.getDocument()
    const range = editor.getSelectedRange()
    if (!range || range[0] !== range[1] || range[0] < 3) return

    const cursor = range[0]
    const before = doc.toString().slice(Math.max(0, cursor - 20), cursor)
    const match = before.match(SHORTCODE_REGEX)
    if (!match) return

    const code = match[1]
    const emoji = SHORTCODES[code]
    if (!emoji) return

    this.isExpanding = true
    try {
      editor.setSelectedRange([cursor - code.length, cursor])
      editor.insertString(emoji)
    } finally {
      this.isExpanding = false
    }
  }

  handleTextareaInput() {
    if (this.isExpanding || !this.hasTextareaTarget) return
    const ta = this.textareaTarget
    const cursor = ta.selectionStart
    if (cursor == null || cursor < 3) return

    const before = ta.value.slice(0, cursor)
    const match = before.match(SHORTCODE_REGEX)
    if (!match) return

    const code = match[1]
    const emoji = SHORTCODES[code]
    if (!emoji) return

    this.isExpanding = true
    try {
      ta.setRangeText(emoji, cursor - code.length, cursor, "end")
    } finally {
      this.isExpanding = false
    }
  }
}
