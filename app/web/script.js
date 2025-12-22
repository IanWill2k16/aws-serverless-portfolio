const API_BASE_URL = "__API_BASE_URL__";

async function loadPage() {
    const responseElement = document.getElementById("response");

    try {
        const res = await fetch(`${API_BASE_URL}/visit`);
        const data = await res.json();
        responseElement.textContent = `Visitor count: ${data.count}`;
    } catch (err) {
        responseElement.textContent = "Error loading API";
        console.error(err);
    }
}

loadPage();

const toggle = document.getElementById("theme-toggle");
const root = document.documentElement;

function setTheme(theme) {
    root.setAttribute("data-theme", theme);
    localStorage.setItem("theme", theme);
    toggle.textContent = theme === "dark" ? "☀️" : "🌙";
}

const savedTheme = localStorage.getItem("theme");

if (savedTheme) {
    setTheme(savedTheme);
} else {
    toggle.textContent = window.matchMedia("(prefers-color-scheme: dark)").matches
        ? "☀️"
        : "🌙";
}

toggle.addEventListener("click", () => {
    const current = root.getAttribute("data-theme");
    setTheme(current === "dark" ? "light" : "dark");
});
