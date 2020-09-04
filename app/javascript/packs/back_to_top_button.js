const mybutton = document.getElementById("backToTop");
// When the user scrolls down 700px from the top of the document, show the button
window.onscroll = function displayFunction() {
  if (
    document.body.scrollTop > 700 ||
    document.documentElement.scrollTop > 700
  ) {
    mybutton.style.display = "block";
  } else {
    mybutton.style.display = "none";
  }
};

mybutton.addEventListener("click", function scrollToTop() {
  window.scrollTo({ top: 0, behavior: "smooth" });
});
