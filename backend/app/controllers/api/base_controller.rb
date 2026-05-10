module Api
  class BaseController < ApplicationController
    private

    def current_user
      return @current_user if defined?(@current_user)

      @current_user = user_from_authorization_header
    end

    def current_token_payload
      return @current_token_payload if defined?(@current_token_payload)

      token = bearer_token
      @current_token_payload = token.present? ? JsonWebToken.decode(token) : nil
    rescue JsonWebToken::DecodeError
      @current_token_payload = nil
    end

    def authenticate_user!
      return if current_user

      render_error("Unauthorized", status: :unauthorized)
    end

    def require_staff!
      return if current_user&.moderator? || current_user&.admin?

      render_error("Forbidden", status: :forbidden)
    end

    def render_forbidden(message = "Forbidden")
      render_error(message, status: :forbidden)
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
      payload = current_token_payload
      return nil if payload.blank? || JsonWebToken.revoked?(payload)

      User.active.find_by(id: payload[:user_id])
    end

    def bearer_token
      header = request.headers["Authorization"].to_s
      return unless header.start_with?("Bearer ")

      header.delete_prefix("Bearer ").strip
    end

    def visible_recipes_relation
      scope = Recipe.all
      return scope if current_user&.admin?

      public_scope = scope.where(visibility: Recipe.visibilities[:public_recipe])
      return public_scope unless current_user

      public_scope.or(scope.where(user_id: current_user.id))
    end

    def editable_recipes_relation
      return Recipe.all if current_user&.admin?
      return Recipe.none unless current_user

      current_user.recipes
    end
  end
end
