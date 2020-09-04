import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["addItem", "template"];

  connect() {
    this.initializeSlimSelect();
  }

  addAssociation(event) {
    event.preventDefault();
    const content = this.templateTarget.innerHTML.replace(
      /TEMPLATE_RECORD/g,
      new Date().valueOf()
    );
    this.addItemTarget.insertAdjacentHTML("beforebegin", content);
    this.initializeSlimSelect();
  }

  removeAssociation(event) {
    event.preventDefault();
    const item = event.target.closest(".nested-fields");
    item.querySelector("input[name*='_destroy']").value = 1;
    item.style.display = "none";
  }
  
  initializeSlimSelect() {
    document.addEventListener("turbolinks:load", () => {
      document.querySelectorAll(".SlimSelect").forEach((node) => {
        new window.SlimSelect({
          select: node,
        });
      });
    });
  }
}
