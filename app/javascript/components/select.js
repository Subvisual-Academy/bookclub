import SlimSelect from "slim-select";

/* eslint-disable no-new */

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll(".SlimSelect").forEach((node) => {
    new SlimSelect({
      select: node,
    });
  });
});
