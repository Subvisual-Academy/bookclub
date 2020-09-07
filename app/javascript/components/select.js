import SlimSelect from "slim-select";

document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll(".SlimSelect").forEach((node) => {
    // eslint-disable-next-line no-new
    new SlimSelect({
      select: node,
    });
  });
});
