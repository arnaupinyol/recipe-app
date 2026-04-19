module Api
  class StatusController < BaseController
    def show
      render_success({
        status: "ok",
        app: "recipe_app",
        api: "ready"
      })
    end
  end
end
