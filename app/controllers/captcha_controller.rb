class CaptchaController < ApplicationController

  def generate_challenge
    scope = params[:scope] || "default"
    scope = params[:scope] || "default"
    challenge_token = CaptchaService.generate_challenge(scope)

    render json: { challenge_token: challenge_token }
  end

  def verify_challenge
    challenge_token = params[:challenge_token]
    submitted_nonce = params[:nonce]

    access_token = CaptchaService.verify_challenge(challenge_token, submitted_nonce)

    if access_token
      render json: { success: true, access_token: access_token }
    else
      render json: { success: false, message: "Invalid solution or challenge expired" }, status: :unprocessable_entity
    end
  end
end
