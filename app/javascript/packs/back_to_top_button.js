mybutton = document.getElementById("backToTop");
// When the user scrolls down 20px from the top of the document, show the button
window.onscroll = function() {displayFunction()};

function displayFunction() {
    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
        mybutton.style.display = "block";
    } else {
        mybutton.style.display = "none";
    }
}

mybutton.addEventListener("click", function scrollToTop() {
    window.scrollTo({top: 0, behavior: "smooth"});
})


