const mybutton = document.getElementById("backToTop");
// When the user scrolls down 300px from the top of the document, show the button
window.onscroll = function displayFunction() {
  if (
    document.body.scrollTop > 300 ||
    document.documentElement.scrollTop > 300
  ) {
    mybutton.style.display = "block";
  } else {
    mybutton.style.display = "none";
  }
};

mybutton.addEventListener("click", function scrollToTop() {
  window.scrollTo({ top: 0, behavior: "smooth" });
});
