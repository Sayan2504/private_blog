import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["status"]
  static values = {
    delay: { type: Number, default: 2000 },
    enabled: { type: Boolean, default: true }
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  schedule() {
    if (!this.enabledValue) return

    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.save(), this.delayValue)
  }

  async save() {
    const titleInput = this.element.querySelector("[name='post[title]']")
    if (!titleInput || !titleInput.value.trim()) return

    if (this.hasStatusTarget) {
      this.statusTarget.textContent = "Saving..."
    }

    const body = new FormData(this.element)
    const method = this.element.querySelector("input[name='_method']")?.value || this.element.method || "post"

    try {
      const response = await fetch(this.element.action, {
        method: method.toUpperCase() === "PATCH" ? "PATCH" : "POST",
        headers: { Accept: "application/json" },
        body
      })

      if (!response.ok) return

      const data = await response.json()
      if (data.url && this.element.action !== data.url) {
        this.element.action = data.url
        let methodField = this.element.querySelector("input[name='_method']")
        if (!methodField) {
          methodField = document.createElement("input")
          methodField.type = "hidden"
          methodField.name = "_method"
          this.element.appendChild(methodField)
        }
        methodField.value = "patch"
      }

      if (this.hasStatusTarget) {
        this.statusTarget.textContent = `Saved at ${data.saved_at}`
      }
    } catch {
      if (this.hasStatusTarget) {
        this.statusTarget.textContent = "Autosave failed"
      }
    }
  }
}

