module Api
  module Auth
    class RegistrationsController < BaseController
      def create
        user = User.new(registration_params)

        if user.save
          render_success(auth_payload(user), status: :created)
        else
          render_error("Registration failed", details: user.errors.to_hash)
        end
      end

      private

      def registration_params
        params.require(:user).permit(
          :username,
          :email,
          :password,
          :password_confirmation,
          :language
        )
      end

      def auth_payload(user)
        {
          token: JsonWebToken.encode(user_id: user.id),
          user: UserSerializer.render(user)
        }
      end
    end
  end
end
