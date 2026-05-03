module Api
  module Auth
    class SessionsController < BaseController
      before_action :authenticate_user!, only: :destroy

      def create
        user = User.find_by(email: login_params[:email].to_s.strip.downcase)
        secret = login_params[:password]

        if user&.authenticate(secret)
          return render_error("Account is not active", status: :forbidden) unless user.active?

          render_success(auth_payload(user))
        else
          render_error("Invalid email or password", status: :unauthorized)
        end
      end

      def destroy
        render_success({ message: "Logged out" })
      end

      private

      def login_params
        params.require(:user).permit(:email, :password)
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
