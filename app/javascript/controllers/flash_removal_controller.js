import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.initializeRemoval();
  }

  initializeRemoval() {
    setTimeout(() => {
      this.remove();
    }, 2000);
  }

  remove() {
    this.element.remove();
  }
}
