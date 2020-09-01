var coll = document.getElementsByClassName("collapsible-button")

for (let i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function () {
        this.classList.toggle("active");
        var content = this.nextElementSibling;
        var arrow_image = this.getElementsByTagName("img")[0];
        if (content.style.maxHeight) {
            content.style.maxHeight = null;
            arrow_image.src = "assets/expand_arrow.png";
        } else {
            content.style.display = "block";
            content.style.maxHeight = content.scrollHeight + "px";
            arrow_image.src = "assets/collapse_arrow.png";
        }
    });
}
