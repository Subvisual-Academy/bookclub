import { Controller } from "stimulus"

const autocomplete_user = (element) => {
  const options = {
    url: function(phrase) {
      return "/users/search.json?q=" + phrase;
    },
    getValue: "name",
  };

  $(element).find('[data-behaviour="autocomplete_user"]').easyAutocomplete(options);
}

const autocomplete_book = (element) => {
  const options = {
    url: function(phrase) {
      return "/book/search.json?q=" + phrase;
    },
    getValue: "title",
  };

  $(element).find('[data-behaviour="autocomplete_book"]').easyAutocomplete(options);
}

export default class extends Controller {
  static targets = ["add_item", "template"]

  addAssociation(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, new Date().valueOf())
    this.add_itemTarget.insertAdjacentHTML('beforebegin', content)
    autocomplete_user(this.element)
    autocomplete_book(this.element)
  }

  removeAssociation(event) {
    event.preventDefault()
    const item = event.target.closest(".nested-fields")
    item.querySelector("input[name*='_destroy']").value = 1
    item.style.display = 'none'
  }
}
