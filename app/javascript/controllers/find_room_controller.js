import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "pick"]

  showSearch(){
    this.pickTarget.classList.add("hidden")
    this.searchTarget.classList.remove("hidden")
  }

  showPick() {
    this.pickTarget.classList.remove("hidden")
    this.searchTarget.classList.add("hidden")
  }
}