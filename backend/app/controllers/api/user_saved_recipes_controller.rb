module Api
  class UserSavedRecipesController < BaseController
    before_action :set_user_saved_recipe, only: [ :show, :update, :destroy ]

    def index
      saved_recipes = UserSavedRecipe.includes(:user, :recipe).order(created_at: :desc)

      render_success({ user_saved_recipes: saved_recipes.map { |saved_recipe| UserSavedRecipeSerializer.render(saved_recipe) } })
    end

    def show
      render_success({ user_saved_recipe: UserSavedRecipeSerializer.render(@user_saved_recipe) })
    end

    def create
      saved_recipe = UserSavedRecipe.new(user_saved_recipe_params)

      if saved_recipe.save
        render_success({ user_saved_recipe: UserSavedRecipeSerializer.render(saved_recipe) }, status: :created)
      else
        render_error("Saved recipe creation failed", details: normalized_errors(saved_recipe))
      end
    end

    def update
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

    def set_user_saved_recipe
      @user_saved_recipe = UserSavedRecipe.includes(:user, :recipe).find_by(id: params[:id])
      return if @user_saved_recipe

      render_error("Saved recipe not found", status: :not_found)
    end

    def user_saved_recipe_params
      params.require(:user_saved_recipe).permit(:user_id, :recipe_id)
    end

    def normalized_errors(record)
      details = record.errors.to_hash
      details[:user_id] = [ "contains an invalid value" ] if details.delete(:user) == [ "must exist" ]
      details[:recipe_id] = [ "contains an invalid value" ] if details.delete(:recipe) == [ "must exist" ]
      details
    end
  end
end
