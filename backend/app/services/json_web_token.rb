class JsonWebToken
  ALGORITHM = "HS256"
  EXPIRATION_TIME = 24.hours

  class DecodeError < StandardError; end

  def self.encode(expires_at: EXPIRATION_TIME.from_now, **payload)
    token_payload = payload.merge(exp: expires_at.to_i, jti: payload[:jti] || SecureRandom.uuid)
    JWT.encode(token_payload, secret_key, ALGORITHM)
  end

  def self.decode(token)
    decoded_token = JWT.decode(token, secret_key, true, { algorithm: ALGORITHM })
    decoded_token.first.with_indifferent_access
  rescue JWT::DecodeError, JWT::ExpiredSignature
    raise DecodeError
  end

  def self.revoke!(payload)
    return if payload.blank? || payload[:jti].blank? || payload[:exp].blank?

    RevokedToken.find_or_create_by!(jti: payload[:jti]) do |revoked_token|
      revoked_token.expires_at = Time.zone.at(payload[:exp].to_i)
    end
  end

  def self.revoked?(payload)
    RevokedToken.revoked?(payload[:jti])
  end

  def self.secret_key
    Rails.application.secret_key_base
  end
end
