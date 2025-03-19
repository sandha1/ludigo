import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="filter"
export default class extends Controller {
  static targets = ["input"]

  check(e) {
    this.inputTargets.forEach(input => {
      if (input !== e.currentTarget) {
        input.checked = false
      }
    });
  }
}
