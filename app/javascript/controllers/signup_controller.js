import { Controller } from "@hotwired/stimulus"
import Captcha from "captcha";

export default class extends Controller {

    connect() {
        const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
        console.log(csrfToken)
        new Captcha('signup-form', csrfToken);
    }

}
