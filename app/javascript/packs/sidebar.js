var hidden = true;
    document.toggleSidebar = (event) => {
        const sidebarElement = event.currentTarget;
        if (hidden) {
            sidebarElement.style.width = "20%";
            hidden = false;
        } else {
            sidebarElement.style.width = "5%";
            sidebarElement.style.paddingLeft = "1%";
            hidden = true;
        }
    }
