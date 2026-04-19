class JsonWebToken
  ALGORITHM = "HS256"
  EXPIRATION_TIME = 24.hours

  class DecodeError < StandardError; end

  def self.encode(expires_at: EXPIRATION_TIME.from_now, **payload)
    token_payload = payload.merge(exp: expires_at.to_i)
    JWT.encode(token_payload, secret_key, ALGORITHM)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
    decoded_token.first.with_indifferent_access
  rescue JWT::DecodeError, JWT::ExpiredSignature
    raise DecodeError
  end

  def self.secret_key
    Rails.application.secret_key_base
  end
end
