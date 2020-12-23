document.addEventListener("turbo:load", setupPopups);

window.openPopup = async (url) => {
  closeOtherPopups();

  const response = await fetch(url);
  const html = await response.text();

  document.body.children[0].insertAdjacentHTML("afterend", html);
};

function setupPopups() {
  const popupDivs = document.querySelectorAll(".u-popup");

  popupDivs.forEach((popupDiv) => {
    popupDiv.addEventListener("click", async () => {
      closeOtherPopups();

      const response = await fetch(popupDiv.dataset.url);
      const html = await response.text();

      document.body.children[0].insertAdjacentHTML("afterend", html);
    });
  });
}

function closeOtherPopups() {
  document
    .querySelectorAll(".u-popupContent")
    .forEach((popup) => popup.remove());
}
