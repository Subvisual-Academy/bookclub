document.addEventListener("turbolinks:load", addButtonAction);

function addButtonAction() {
  const goToTopButton = document.querySelector("#backToTop");

  if (goToTopButton) {
    // When the user scrolls down 300px from the top of the document, show the button
    window.onscroll = function displayFunction() {
      if (
        document.body.scrollTop > 300 ||
        document.documentElement.scrollTop > 300
      ) {
        goToTopButton.style.display = "block";
      } else {
        goToTopButton.style.display = "none";
      }
    };

    goToTopButton.addEventListener("click", function scrollToTop() {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }
}
