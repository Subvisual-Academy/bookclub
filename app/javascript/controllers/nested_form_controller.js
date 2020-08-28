import { Controller } from "stimulus"

const autocomplete = (element) => {
  const options = {
    url: function(phrase) {
      return "/users/search.json?q=" + phrase;
    },
    getValue: "name",
  };

  $(element).find('[data-behaviour="autocomplete"]').easyAutocomplete(options);
}

// function buildhidden() {
//   const joinedvalues = document.getElementById('user_id').value;
//   document.getElementById("user_id").value = joinedvalues;
// }

export default class extends Controller {
  static targets = ["add_item", "template"]

  addAssociation(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, new Date().valueOf())
    this.add_itemTarget.insertAdjacentHTML('beforebegin', content)
    autocomplete(this.element)
  }

  removeAssociation(event) {
    event.preventDefault()
    const item = event.target.closest(".nested-fields")
    item.querySelector("input[name*='_destroy']").value = 1
    item.style.display = 'none'
  }
}
