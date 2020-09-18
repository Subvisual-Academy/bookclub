document.addEventListener("turbolinks:load", addPopupRemotes);

function addPopupRemotes() {
  const popupDivs = document.querySelectorAll(".u-popupRemote");

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
    .querySelectorAll(".u-remotePopupContent")
    .forEach((popup) => popup.remove());
}
