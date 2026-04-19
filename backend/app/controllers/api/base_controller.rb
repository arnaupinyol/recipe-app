module Api
  class BaseController < ApplicationController
    private

    def current_user
      return @current_user if defined?(@current_user)

      @current_user = user_from_authorization_header
    end

    def authenticate_user!
      return if current_user

      render_error("Unauthorized", status: :unauthorized)
    end

    def render_success(data = {}, status: :ok)
      render json: data, status: status
    end

    def render_error(message, status: :unprocessable_entity, details: nil)
      payload = { error: { message: message } }
      payload[:error][:details] = details if details.present?

      render json: payload, status: status
    end

    def user_from_authorization_header
      token = bearer_token
      return nil if token.blank?

      payload = JsonWebToken.decode(token)
      User.active.find_by(id: payload[:user_id])
    rescue JsonWebToken::DecodeError
      nil
    end

    def bearer_token
      header = request.headers["Authorization"].to_s
      return unless header.start_with?("Bearer ")

      header.delete_prefix("Bearer ").strip
    end
  end
end
