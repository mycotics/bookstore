class JwtService
  SECRET_KEY = Rails.application.credentials.secret_key_base

  def self.encode(payload)
    payload[:exp] = 6.months.from_now.to_i # Set expiration to 24 hours
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError => e
    nil
  end
end
