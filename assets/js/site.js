const navButton = document.querySelector(".nav-toggle");
const nav = document.querySelector(".site-nav");
navButton?.addEventListener("click", () => {
  const open = navButton.getAttribute("aria-expanded") === "true";
  navButton.setAttribute("aria-expanded", String(!open));
  nav.classList.toggle("is-open", !open);
});
document.querySelector(".theme-toggle")?.addEventListener("click", () => {
  const current = document.documentElement.dataset.theme;
  const dark =
    current === "dark" ||
    (current === "auto" && matchMedia("(prefers-color-scheme: dark)").matches);
  const next = dark ? "light" : "dark";
  document.documentElement.dataset.theme = next;
  localStorage.setItem("theme", next);
});
document.querySelectorAll(".accordion button").forEach((button) =>
  button.addEventListener("click", () => {
    const accordion = button.closest(".accordion");
    const open = button.getAttribute("aria-expanded") === "true";
    button.setAttribute("aria-expanded", String(!open));
    accordion.classList.toggle("is-closed", open);
    button.querySelector("span").textContent = open ? "+" : "−";
  })
);
const lightbox = document.querySelector(".lightbox");
document.querySelectorAll(".prose img").forEach((source) => {
  source.tabIndex = 0;
  source.setAttribute("role", "button");
  source.setAttribute("aria-label", `${source.alt || "Image"}, open larger preview`);
  const open = () => {
    const preview = lightbox.querySelector("img");
    preview.src = source.currentSrc || source.src;
    preview.alt = source.alt;
    lightbox.showModal();
  };
  source.addEventListener("click", open);
  source.addEventListener("keydown", (event) => {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      open();
    }
  });
});
lightbox?.querySelector("button").addEventListener("click", () => lightbox.close());
lightbox?.addEventListener("click", (event) => {
  if (event.target === lightbox) lightbox.close();
});
