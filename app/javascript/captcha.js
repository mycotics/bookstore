export default class Captcha {

    static CAPTCHA_GENERATE_URL = '/captcha/generate-challenge';
    static CAPTCHA_VERIFY_URL = '/captcha/verify-challenge';

    constructor(formId, csrf) {
        this.form = document.getElementById(formId);
        this.submitButton = this.form.querySelector('button[type="submit"]');
        this.buttonText = this.submitButton.textContent.trim();
        this.scope = '';
        this.captchaStarted = false;
        this.captchaPromise = undefined;
        this.csrfToken = csrf;
        this.initialize();
    }

    initialize() {
        this.form.addEventListener('focusin', () => {
            this.captchaPromise = this.startCaptcha();
        });
        this.form.addEventListener('submit', (e) => this.handleSubmit(e));
    }

    async startCaptcha() {
        if (this.captchaStarted) return;
        this.captchaStarted = true;
        this.submitButton.disabled = true;


        try {
            this.submitButton.textContent = 'Testing humanity... Please Wait...';

            const challengeToken = await this.generateChallenge()
            const payload = this.decodeJWT(challengeToken);
            const { challenge, difficulty, scope } = payload
            const solutionNonce = await this.solveChallenge(challenge, difficulty);

            const accessToken = await this.verifyChallenge(challengeToken, solutionNonce);

            // Add the token to the form as a hidden input
            const tokenInput = document.createElement('input');
            tokenInput.type = 'hidden';
            tokenInput.name = 'access_token';
            tokenInput.value = accessToken;
            this.form.appendChild(tokenInput);

            this.submitButton.disabled = false;

            this.submitButton.textContent = this.buttonText;
        } catch (error) {
            this.submitButton.textContent = 'Are you a bot?';
        }
    }

    async generateChallenge() {
        const response = await fetch(Captcha.CAPTCHA_GENERATE_URL, {
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': this.csrfToken
            },
            method: 'POST',
            credentials: 'include'
        });
        const data = await response.json();
        return data.challenge_token;
    }

    async solveChallenge(challenge, difficulty) {
        let nonce = 0;
        const prefix = '0'.repeat(difficulty);
        while (true) {
            const hash = await this.sha256(challenge + nonce);
            if (hash.startsWith(prefix)) {
                return nonce.toString();
            }
            nonce++;
        }
    }

    async verifyChallenge(token, nonce){
        try {

            const response = await fetch(Captcha.CAPTCHA_VERIFY_URL, {
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': this.csrfToken
                },
                method: 'POST',
                credentials: 'include',
                body: JSON.stringify({ challenge_token: token, nonce: nonce }),
            });
            const result = await response.json();
            return result.access_token;

        } catch (error) {
            console.log("verification error")
        }
    }

    async handleSubmit(e) {
        e.preventDefault();
        await this.captchaPromise
        this.form.submit();
    }

    async sha256(message) {
        const msgBuffer = new TextEncoder().encode(message);
        const hashBuffer = await crypto.subtle.digest('SHA-256', msgBuffer);
        return Array.from(new Uint8Array(hashBuffer))
            .map((b) => b.toString(16).padStart(2, '0'))
            .join('');
    }

    decodeJWT(token) {
        try {
            const payloadBase64 = token.split('.')[1]; // The payload is the second part
            const payloadDecoded = atob(payloadBase64.replace(/-/g, '+').replace(/_/g, '/'));
            return JSON.parse(payloadDecoded); // Parse the JSON content
        } catch (e) {
            console.error('Failed to decode JWT', e);
            return {};
        }
    }

}