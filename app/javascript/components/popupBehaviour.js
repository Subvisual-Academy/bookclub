document.addEventListener("turbolinks:load", addPopupAction);

function addPopupAction() {
  const popupDivs = document.querySelectorAll(".u-popup");

  popupDivs.forEach((popupDiv) => {
    popupDiv.addEventListener("click", function showPopup() {
      const popupContent = popupDiv.querySelectorAll(".u-popupContent")[0];
      popupContent.classList.toggle("u-show");
      closeOtherPopups(popupDiv);
    });
  });
}

function closeOtherPopups(currentPopup) {
  const popupDivs = document.querySelectorAll(".u-popup");

  popupDivs.forEach((popupDiv) => {
    if (popupDiv !== currentPopup) {
      const popupContent = popupDiv.querySelectorAll(".u-popupContent")[0];
      popupContent.classList.remove("u-show");
    }
  });
}
