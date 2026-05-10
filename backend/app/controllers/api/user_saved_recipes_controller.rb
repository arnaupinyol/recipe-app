module Api
  class UserSavedRecipesController < BaseController
    before_action :authenticate_user!
    before_action :set_user_saved_recipe, only: [ :show, :update, :destroy ]

    def index
      saved_recipes = user_saved_recipes_scope.order(created_at: :desc)

      render_success({ user_saved_recipes: saved_recipes.map { |saved_recipe| UserSavedRecipeSerializer.render(saved_recipe) } })
    end

    def show
      render_success({ user_saved_recipe: UserSavedRecipeSerializer.render(@user_saved_recipe) })
    end

    def create
      return unless ensure_visible_recipe_param!("Saved recipe creation failed")

      saved_recipe = current_user.user_saved_recipes.new(user_saved_recipe_params)

      if saved_recipe.save
        render_success({ user_saved_recipe: UserSavedRecipeSerializer.render(saved_recipe) }, status: :created)
      else
        render_error("Saved recipe creation failed", details: normalized_errors(saved_recipe))
      end
    end

    def update
      return unless ensure_visible_recipe_param!("Saved recipe update failed")

      if @user_saved_recipe.update(user_saved_recipe_params)
        render_success({ user_saved_recipe: UserSavedRecipeSerializer.render(@user_saved_recipe) })
      else
        render_error("Saved recipe update failed", details: normalized_errors(@user_saved_recipe))
      end
    end

    def destroy
      @user_saved_recipe.destroy
      render_success({ message: "Saved recipe deleted" })
    end

    private

    def user_saved_recipes_scope
      scope = UserSavedRecipe.includes(:user, :recipe)
      return scope if current_user.admin?

      scope.where(user_id: current_user.id)
    end

    def ensure_visible_recipe_param!(message)
      recipe_id = params.dig(:user_saved_recipe, :recipe_id)
      return true if recipe_id.blank? || visible_recipes_relation.where(id: recipe_id).exists?

      render_error(message, details: { recipe_id: [ "contains an invalid value" ] })
      false
    end

    def set_user_saved_recipe
      @user_saved_recipe = user_saved_recipes_scope.find_by(id: params[:id])
      return if @user_saved_recipe

      render_error("Saved recipe not found", status: :not_found)
    end

    def user_saved_recipe_params
      params.require(:user_saved_recipe).permit(:recipe_id)
    end

    def normalized_errors(record)
      details = record.errors.to_hash
      details[:recipe_id] = [ "contains an invalid value" ] if details.delete(:recipe) == [ "must exist" ]
      details
    end
  end
end
