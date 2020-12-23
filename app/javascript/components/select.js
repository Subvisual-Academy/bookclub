import SlimSelect from "slim-select";

document.addEventListener("turbo:load", () => {
  document.querySelectorAll(".SlimSelect").forEach((node) => {
    // eslint-disable-next-line no-new
    new SlimSelect({
      select: node,
    });
  });
});
