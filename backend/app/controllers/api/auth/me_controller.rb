module Api
  module Auth
    class MeController < BaseController
      before_action :authenticate_user!

      def show
        render_success({ user: UserSerializer.render(current_user) })
      end
    end
  end
end
