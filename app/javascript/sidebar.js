var hidden = true;
document.toggleSidebar = (event) => {
    const sidebarElement = event.currentTarget;
    if (hidden) {
        sidebarElement.style.width = "21.5%";
        hidden = false;
    } else {
        sidebarElement.style.width = "5%";
        sidebarElement.style.paddingLeft = "1.2%";
        hidden = true;
    }
}
