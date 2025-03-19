import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="activities-form"
export default class extends Controller {

  connect() {
    console.log("Activities Form controller connecté");
  }

  updateFilters() {
    const formData = new FormData(this.element)
    const url = '/activities?'
    let paramsArray = []

    for (var pair of formData.entries()) {
      if (pair[0] === "query" && pair[1].length <= 3) continue

      paramsArray.push(pair.join('='));
    }

    const finalUrl = url + paramsArray.join('&')
    fetch(finalUrl, {
      method: 'GET',
      headers: {
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').textContent,
        'Accept': 'text/vnd.turbo-stream.html, text/html',
        'Content-Type': 'application/json'
      }
    }).then((response) => {
      return response.text().then((response) => {
        Turbo.renderStreamMessage(response)
      })
    })
  }
}
