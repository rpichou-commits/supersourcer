import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "poste", "localisation", "experience", "competences", "industrie"]

  connect() {
  console.log("criteria controller connected")
  }

  analyze() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => this.fetchCriteria(), 600)
  }

  async fetchCriteria() {
    const response = await fetch("/searches/analyze", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ text: this.inputTarget.value })
    })
    const data = await response.json()

    this.posteTarget.classList.toggle("detected", data.poste)
    this.localisationTarget.classList.toggle("detected", data.localisation)
    this.experienceTarget.classList.toggle("detected", data.annees_experience)
    this.competencesTarget.classList.toggle("detected", data.competences)
    this.industrieTarget.classList.toggle("detected", data.industrie)
  }
}
