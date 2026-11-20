import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog", "input", "form"]

  connect() {
    this.onKeydown = (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key.toLowerCase() === "k") {
        e.preventDefault()
        this.open()
      } else if (e.key === "Escape") {
        this.close()
      }
    }
    window.addEventListener("keydown", this.onKeydown)
  }

  disconnect() {
    window.removeEventListener("keydown", this.onKeydown)
    clearTimeout(this.timeout)
    clearTimeout(this.closeTimeout)
  }

  open() {
    if (!this.hasDialogTarget) return
    clearTimeout(this.closeTimeout)
    this.dialogTarget.classList.remove("hidden")
    requestAnimationFrame(() => {
      this.dialogTarget.dataset.open = "true"
    })
    if (this.hasInputTarget) {
      this.inputTarget.focus()
      this.formTarget?.requestSubmit()
    }
  }

  close() {
    if (!this.hasDialogTarget) return
    delete this.dialogTarget.dataset.open
    const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches
    if (reduced) {
      this.dialogTarget.classList.add("hidden")
      return
    }
    clearTimeout(this.closeTimeout)
    this.closeTimeout = setTimeout(() => {
      if (!this.dialogTarget.dataset.open) {
        this.dialogTarget.classList.add("hidden")
      }
    }, 220)
  }

  backdropClick(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget?.requestSubmit()
    }, 200)
  }
}

