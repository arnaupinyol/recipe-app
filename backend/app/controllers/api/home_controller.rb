module Api
  class HomeController < BaseController
    def index
      recipes = home_recipes_scope
                .includes(
                  :user,
                  :categories,
                  :comments,
                  :user_recipe_likes,
                  :user_saved_recipes,
                  utensils: { image_attachment: :blob },
                  recipe_images: { image_attachment: :blob },
                  recipe_ingredients: { ingredient: { image_attachment: :blob } },
                  steps: { step_images: { image_attachment: :blob } }
                )
                .order(created_at: :desc)

      render_success({
        recipes: recipes.map do |recipe|
          HomeRecipeSerializer.render(recipe, current_user: current_user, base_url: request.base_url)
        end
      })
    end

    private

    def home_recipes_scope
      scope = visible_recipes_relation

      return following_recipes_scope(scope) if params[:feed] == "following"

      scope
    end

    def following_recipes_scope(scope)
      return Recipe.none unless current_user

      scope.where(user_id: current_user.followed_users.select(:id))
    end
  end
end
