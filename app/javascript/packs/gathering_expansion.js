var coll = document.getElementsByClassName("collapsible-button")

for (let i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function () {
        this.classList.toggle("active");
        var content = this.nextElementSibling;
        var arrow_image = this.getElementsByTagName("img")[0];
        if (content.style.maxHeight) {
            content.style.maxHeight = null;
            content.style.paddingTop="0";
            arrow_image.src = "assets/expand_arrow.png";
        } else {
            closeOtherGatherings(coll, this);
            content.style.maxHeight = content.scrollHeight + "px";
            arrow_image.src = "assets/collapse_arrow.png";
            content.style.paddingTop="15px"
        }
    });
}

function closeOtherGatherings(gatherings, element) {
    for (let i = 0; i < coll.length; i++) {
        if(gatherings[i] !== element) {
            const content = gatherings[i].nextElementSibling;
            const arrow_image = gatherings[i].getElementsByTagName("img")[0];
            if (content.style.maxHeight) {
                content.style.maxHeight = null;
                content.style.paddingTop="0";
                arrow_image.src = "assets/expand_arrow.png";
            }
        }
    }
}
