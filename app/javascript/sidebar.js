window.addEventListener("DOMContentLoaded", () => {
  const sidebarElement = document.querySelector("#sidebar");
  let afterNavigation = false;

  document.addEventListener("turbolinks:visit", () => {
    afterNavigation = true;

    closeSidebar();
  });

  sidebarElement.addEventListener("mouseover", () => {
    if (afterNavigation) return;

    const mouseIsInSidebar = sidebarElement.contains(getElementUnderMouse());

    if (!mouseIsInSidebar) return;

    openSidebar();
  });

  sidebarElement.addEventListener("mouseout", () => {
    const mouseIsInSidebar = sidebarElement.contains(getElementUnderMouse());

    if (mouseIsInSidebar) return;

    afterNavigation = false;
    closeSidebar();
  });

  function closeSidebar() {
    sidebarElement.style.width = "5%";
    sidebarElement.style.paddingLeft = "1.2%";
  }

  function openSidebar() {
    sidebarElement.style.width = "21.5%";
  }

  function getElementUnderMouse() {
    const nodes = document.querySelectorAll(":hover");

    return nodes[nodes.length - 1];
  }
});
