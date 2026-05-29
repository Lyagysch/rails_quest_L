// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

const isQuestPage = () => /^\/quests\/\d+/.test(window.location.pathname)

const shouldReloadQuestPage = (event) => {
	if (!isQuestPage()) return false

	if (event.persisted) return true

	const navigationEntry = performance.getEntriesByType("navigation")[0]
	return navigationEntry?.type === "back_forward"
}

window.addEventListener("pageshow", (event) => {
	if (shouldReloadQuestPage(event)) {
		window.location.reload()
	}
})
