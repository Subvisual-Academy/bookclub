document.addEventListener("turbolinks:load", addPopupAction);

function addPopupAction() {
    const popupDivs = document.querySelectorAll(".Books-popup");

    popupDivs.forEach((popupDiv) => {
        popupDiv.addEventListener("click", function showPopup() {
            const popupContent = popupDiv.querySelectorAll(".Books-popuptext")[0];
            popupContent.classList.toggle("Books-show");
            closeOtherPopups(popupDiv);
        })
    });
}

function closeOtherPopups(currentPopup) {
    const popupDivs = document.querySelectorAll(".Books-popup");

    popupDivs.forEach((popupDiv) => {
        if(popupDiv !== currentPopup) {
            const popupContent = popupDiv.querySelectorAll(".Books-popuptext")[0];
            popupContent.classList.remove("Books-show");
        }
    });
}
