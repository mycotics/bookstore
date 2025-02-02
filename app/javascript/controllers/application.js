import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

const consentModal = document.getElementById('consent-modal');
const hasConsented = localStorage.getItem('consentGiven');


if (hasConsented !== 'true') {
    consentModal.classList.remove('hidden');
}

document.getElementById('allow-btn').addEventListener('click', () => {
    const analyticsConsent = document.getElementById('analytics-checkbox').checked;
    const marketingConsent = document.getElementById('marketing-checkbox').checked;

    const consentPreferences = {
        'analytics_storage': analyticsConsent ? 'granted' : 'denied',
        'ad_storage': marketingConsent ? 'granted' : 'denied',
        'ad_user_data': 'denied',
        'ad_personalization': 'denied',
    };
    localStorage.setItem('consentData', JSON.stringify(consentPreferences));

    gtag('consent', 'update', consentPreferences);

    localStorage.setItem('consentGiven', 'true');
    consentModal.classList.add('hidden');
});

document.getElementById('deny-all-btn').addEventListener('click', () => {
    gtag('consent', 'update', {
        'analytics_storage': 'denied',
        'ad_storage': 'denied',
        'ad_user_data': 'denied',
        'ad_personalization': 'denied',
    });

    localStorage.setItem('consentGiven', 'true');
    consentModal.classList.add('hidden');
});


export { application }
