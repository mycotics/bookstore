class CaptchaService
  SECRET_KEY = Rails.application.secret_key_base
  DIFFICULTY = 4

  def self.generate_challenge(scope)
    # Generate a random challenge string
    challenge = SecureRandom.hex(16)

    # JWT payload with challenge and expiry
    payload = {
      exp: Time.now.to_i + 15,
      challenge: challenge,
      difficulty: DIFFICULTY,
      scope: scope
    }
    JWT.encode(payload, SECRET_KEY, 'HS256')
  end
  def self.verify_challenge(challenge_token, submitted_nonce)
    begin
      # Decode JWT and extract challenge
      puts '====444'
      puts challenge_token
      decoded_token = JWT.decode(challenge_token, SECRET_KEY, true)
      challenge = decoded_token.first['challenge']
      scope = decoded_token.first['scope']

      # Recompute hash with nonce and challenge
      combined_string = challenge + submitted_nonce
      hash = Digest::SHA256.hexdigest(combined_string)

      # Verify Proof of Work difficulty
      if hash.start_with?('0' * DIFFICULTY)
        payload = {
          exp: Time.now.to_i + 60 * 2,
          scope: scope,
        }
        # returns an access_token
        JWT.encode(payload, SECRET_KEY, 'HS256')
      end
    rescue JWT::ExpiredSignature
      nil
    rescue JWT::DecodeError
      nil
    end
  end

  def self.verify_access_token(access_token, scope)
    decoded_token = JWT.decode(access_token, SECRET_KEY, true)
    decoded_token.first['scope'] == scope
  end

end
