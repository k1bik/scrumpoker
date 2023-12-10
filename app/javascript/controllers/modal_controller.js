import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "frame"]

  connect() {
    this.modalTarget.addEventListener("close", this.enableBodyScroll.bind(this))
  }

  disconnect() {
    this.modalTarget.removeEventListener("close", this.enableBodyScroll.bind(this))
  }

  submitEnd(e) {
    if (e.detail.success) this.close()
  }

  open() {
    this.modalTarget.showModal()
    document.body.classList.add('overflow-hidden')
  }

  close() {
    this.modalTarget.close()
    this.frameTarget.removeAttribute("src")
    this.frameTarget.innerHTML = ""
  }

  enableBodyScroll() {
    document.body.classList.remove('overflow-hidden')
  }

  clickOutside(event) {
    if (event.target === this.modalTarget) this.close()
  }
}
