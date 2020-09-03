/* eslint-disable no-new */

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll(".SlimSelect").forEach((node) => {
    new window.SlimSelect({
      select: node,
    });
  });
});
