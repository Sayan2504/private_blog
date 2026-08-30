import { Controller } from "@hotwired/stimulus"

const DEFAULT_TITLE = "Are you sure?"
const DEFAULT_LABEL = "Confirm"
const DEFAULT_VARIANT = "primary"

// How long the closing animation runs. Kept in step with
// `.confirm-dialog.is-closing` in application.css — the dialog cannot actually
// close until it has played, or the panel vanishes instead of leaving.
const CLOSE_MS = 160

// How long a confirmation waits for the dialog's controller before giving up
// and letting the browser ask. Only ever reached if the dialog is missing from
// the page entirely — a hung submission would be worse than an ugly prompt.
const READY_TIMEOUT_MS = 2000

// The connected controller, and whoever is waiting for one.
//
// Registration happens here, at module load, rather than in connect(). Turbo
// asks whatever sits at `Turbo.config.forms.confirm` the moment a form is
// submitted, and installing it on connect left a window between page load and
// Stimulus wiring up in which a click fell through to window.confirm — the
// exact dialog this component exists to replace, appearing unpredictably on
// the first interaction after a load.
let active = null
let waiting = []

function whenReady() {
  if (active) return Promise.resolve(active)

  return new Promise((resolve) => {
    waiting.push(resolve)
    setTimeout(() => resolve(null), READY_TIMEOUT_MS)
  })
}

function activate(controller) {
  active = controller
  const resolvers = waiting
  waiting = []
  resolvers.forEach((resolve) => resolve(controller))
}

function ask(message, formElement, submitter) {
  return whenReady().then((controller) =>
    controller ? controller.confirm(message, formElement, submitter) : window.confirm(message)
  )
}

// Idempotent, and attempted twice: once here at import, and again on connect
// in case this module happened to load before Turbo itself.
function install() {
  const forms = window.Turbo?.config?.forms
  if (forms && forms.confirm !== ask) forms.confirm = ask
}

install()

// Replaces window.confirm for every confirmation in the app.
//
// Turbo reads `data-turbo-confirm` off the element and hands the message to
// whatever function sits at `Turbo.config.forms.confirm`, expecting a promise
// that resolves true or false. That is the whole integration: no call site
// changes, and anything that grows a `data-turbo-confirm` later gets this
// dialog automatically.
export default class extends Controller {
  static targets = ["title", "message", "accept", "cancel", "icon"]

  connect() {
    // The clicked element, remembered because it is the only place the extra
    // attributes (title, label, variant) reliably live. Turbo turns a link
    // carrying `data-turbo-method` into a synthesised form before it asks for
    // confirmation, and that form is built with the attributes Turbo knows
    // about — ours are not among them, so reading only what Turbo passes back
    // would lose them on every card's delete link.
    this.onClick = (event) => {
      this.source = event.target.closest?.("[data-turbo-confirm]") || null
    }
    document.addEventListener("click", this.onClick, { capture: true })

    install()
    activate(this)
  }

  disconnect() {
    document.removeEventListener("click", this.onClick, { capture: true })
    this.settle(false)

    // Only stand down if we are still the one on duty — on a Turbo navigation
    // the incoming controller connects before the outgoing one disconnects,
    // and clearing unconditionally would retire the live dialog.
    if (active === this) active = null
  }

  confirm(message, formElement, submitter) {
    // A page swap can leave a stale controller registered. Rather than fight
    // over who owns the hook, a detached one steps aside and lets the browser
    // ask, so a confirmation is never silently skipped.
    if (!this.element.isConnected) return Promise.resolve(window.confirm(message))

    const sources = this.optionsSources(message, formElement, submitter)

    this.titleTarget.textContent = this.read(sources, "turboConfirmTitle") || DEFAULT_TITLE
    this.messageTarget.textContent = message

    const variant = this.read(sources, "turboConfirmVariant") || DEFAULT_VARIANT
    const label = this.read(sources, "turboConfirmLabel") || DEFAULT_LABEL

    this.showVariant(this.iconTargets, variant)
    this.showVariant(this.acceptTargets, variant, label)

    this.element.showModal()

    // Where focus lands depends on what is being confirmed. For an ordinary
    // action the confirm button is the default — you opened the dialog to go
    // ahead, and Enter should do that. For a destructive one it stays on
    // Cancel: Enter must never be the shortcut for deleting something you
    // cannot get back.
    const primary = this.acceptTargets.find((button) => button.style.display !== "none")
    const target = variant === "danger" || !primary ? this.cancelTarget : primary
    target.focus()

    return new Promise((resolve) => {
      this.resolve = resolve
    })
  }

  // Priority order matters. The element the user actually clicked is the one
  // the attributes were written on; Turbo's form and submitter are the
  // fallbacks for a confirmation raised some other way.
  optionsSources(message, formElement, submitter) {
    const clicked =
      this.source?.isConnected && this.source.dataset.turboConfirm === message ? this.source : null

    return [ clicked, submitter, formElement ].filter(Boolean)
  }

  read(sources, key) {
    return sources.map((element) => element.dataset?.[key]).find((value) => value)
  }

  // Both variants are in the DOM with their real component styling; this
  // reveals one. `display` is set directly rather than toggling a `hidden`
  // class, which would be a coin flip against the `inline-flex` already on
  // these elements — same layer, same specificity.
  showVariant(elements, variant, label) {
    elements.forEach((element) => {
      const matches = element.dataset.confirmVariant === variant
      element.style.display = matches ? "" : "none"
      if (matches && label) element.textContent = label
    })
  }

  accept() {
    this.settle(true)
  }

  cancel() {
    this.settle(false)
  }

  // Escape and the backdrop both reach here: <dialog> fires `cancel` for the
  // key, and a click landing on the dialog itself rather than the panel inside
  // it is a click on the backdrop.
  dismiss(event) {
    if (event.type === "click" && event.target !== this.element) return

    event.preventDefault()
    this.settle(false)
  }

  // Called when the dialog closes by any route we did not drive — so a
  // pending promise can never be left unresolved, which would hang the
  // submission Turbo is holding open behind it.
  closed() {
    this.resolve?.(false)
    this.resolve = null
  }

  settle(confirmed) {
    // No pending question, or one already being answered mid-close.
    if (!this.element.open || !this.resolve) return

    const resolve = this.resolve
    this.resolve = null
    resolve(confirmed)
    this.close()
  }

  close() {
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      this.element.close()
      return
    }

    this.element.classList.add("is-closing")
    setTimeout(() => {
      this.element.classList.remove("is-closing")
      this.element.close()
    }, CLOSE_MS)
  }
}
