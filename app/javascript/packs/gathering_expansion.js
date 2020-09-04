// Add the expanding/collapsing behaviour when clicking on the gathering header to all gatherings
const gatherings = document.getElementsByClassName("collapsible-gathering");
for (let index = 0; index < gatherings.length; index += 1) {
  gatherings[index].addEventListener("click", function expandGathering() {
    const gatheringHead = this;
    const content = gatheringHead.nextElementSibling;
    const arrowImage = gatheringHead.getElementsByTagName("img")[0];

    if (content.style.maxHeight) {
      content.style.maxHeight = null;
      arrowImage.src = "assets/expand_arrow.png";
      content.style.paddingTop = "0";
    } else {
      content.style.paddingTop = "15px";
      content.style.maxHeight = `${content.scrollHeight}px`;
      arrowImage.src = "assets/collapse_arrow.png";

      moveGatheringToTopOfWindow(gatheringHead);
    }
  });
}

function moveGatheringToTopOfWindow(gathering) {
  const offset = 35;
  const bodyRect = document.body.getBoundingClientRect().top;
  const elementRect = gathering.getBoundingClientRect().top;
  const elementPosition = elementRect - bodyRect;
  const offsetPosition = elementPosition - offset;
  window.scrollTo({
    top: offsetPosition,
    behavior: "smooth",
  });
}

const collapseUpButtons = document.getElementsByClassName("collapse-up");
for (let index = 0; index < collapseUpButtons.length; index += 1) {
  collapseUpButtons[index].addEventListener("click", function closeGathering() {
    const collapseUpButton = this;
    const gatheringContent = collapseUpButton.parentElement;
    const gatheringHead = gatheringContent.parentElement;
    const arrowImage = gatheringHead.getElementsByTagName("img")[0];

    gatheringContent.style.maxHeight = null;
    gatheringContent.style.paddingTop = "0";
    arrowImage.src = "assets/expand_arrow.png";
  });
}
