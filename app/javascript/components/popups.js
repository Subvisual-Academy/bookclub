document.addEventListener("turbo:before-render", window.cleanupPopups);

// Make clicks outside of the pop close the whole thing
document.addEventListener("click", (event) => {
  const popup = document.querySelector('[data-popup="true"]');

  if (!popup || popup.contains(event.target)) return;

  window.cleanupPopups();
});

window.openPopup = async (url) => {
  window.cleanupPopups();

  const response = await fetch(url);
  const html = await response.text();

  document.body.children[0].insertAdjacentHTML("afterend", html);
};

window.cleanupPopups = () => {
  const popup = document.querySelector('[data-popup="true"]');

  if (!popup) return;

  popup.classList.add("animate-fadeout");
  setTimeout(() => popup.remove(), 250);
};
