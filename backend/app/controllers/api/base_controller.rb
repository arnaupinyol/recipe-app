module Api
  class BaseController < ApplicationController
    private

    def render_success(data = {}, status: :ok)
      render json: data, status: status
    end

    def render_error(message, status: :unprocessable_entity, details: nil)
      payload = { error: { message: message } }
      payload[:error][:details] = details if details.present?

      render json: payload, status: status
    end
  end
end
