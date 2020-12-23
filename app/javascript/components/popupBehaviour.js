document.addEventListener("turbo:before-render", cleanupPopups);

window.openPopup = async (url) => {
  cleanupPopups();

  const response = await fetch(url);
  const html = await response.text();

  document.body.children[0].insertAdjacentHTML("afterend", html);
};

function cleanupPopups() {
  document
    .querySelectorAll(".u-popupContent")
    .forEach((popup) => popup.remove());
}
