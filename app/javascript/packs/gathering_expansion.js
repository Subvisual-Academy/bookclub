const coll = document.getElementsByClassName("collapsible-button");

for (let index = 0; index < coll.length; index += 1) {
  coll[index].addEventListener("click", function expandGathering() {
    this.classList.toggle("active");
    const content = this.nextElementSibling;
    const arrowImage = this.getElementsByTagName("img")[0];
    if (content.style.maxHeight) {
      content.style.maxHeight = null;
      arrowImage.src = "assets/expand_arrow.png";
      content.style.paddingTop = "0";
    } else {
      closeOtherGatherings(coll, this);
      content.style.paddingTop = "15px";
      content.style.maxHeight = `${content.scrollHeight}px`;
      arrowImage.src = "assets/collapse_arrow.png";
    }
  });
}

function closeOtherGatherings(gatherings, element) {
  for (let index = 0; index < coll.length; index += 1) {
    if (gatherings[index] !== element) {
      const content = gatherings[index].nextElementSibling;
      const arrowImage = gatherings[index].getElementsByTagName("img")[0];
      if (content.style.maxHeight) {
        content.style.maxHeight = null;
        content.style.paddingTop = "0";
        arrowImage.src = "assets/expand_arrow.png";
      }
    }
  }
}
