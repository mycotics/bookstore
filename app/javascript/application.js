// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener("turbo:before-fetch-response", (event) => {
    const { fetchResponse } = event.detail;
    const headerValue = fetchResponse.response.headers.get("X-DataLayer");

    if (headerValue) {
        try {
            const eventData = JSON.parse(headerValue);
            window.dataLayer = window.dataLayer || [];
            eventData.forEach(item => {
                window.dataLayer.push(item);
            });
        } catch (error) {
            console.error("Error parsing X-DataLayer header:", error);
        }
    }
});