module Api
  class UserRecipeLikesController < BaseController
    before_action :authenticate_user!
    before_action :set_user_recipe_like, only: [ :show, :update, :destroy ]

    def index
      likes = user_recipe_likes_scope.order(created_at: :desc)

      render_success({ user_recipe_likes: likes.map { |like| UserRecipeLikeSerializer.render(like) } })
    end

    def show
      render_success({ user_recipe_like: UserRecipeLikeSerializer.render(@user_recipe_like) })
    end

    def create
      return unless ensure_visible_recipe_param!("Recipe like creation failed")

      like = current_user.user_recipe_likes.new(user_recipe_like_params)

      if like.save
        render_success({ user_recipe_like: UserRecipeLikeSerializer.render(like) }, status: :created)
      else
        render_error("Recipe like creation failed", details: normalized_errors(like))
      end
    end

    def update
      return unless ensure_visible_recipe_param!("Recipe like update failed")

      if @user_recipe_like.update(user_recipe_like_params)
        render_success({ user_recipe_like: UserRecipeLikeSerializer.render(@user_recipe_like) })
      else
        render_error("Recipe like update failed", details: normalized_errors(@user_recipe_like))
      end
    end

    def destroy
      @user_recipe_like.destroy
      render_success({ message: "Recipe like deleted" })
    end

    private

    def user_recipe_likes_scope
      scope = UserRecipeLike.includes(:user, :recipe)
      return scope if current_user.admin?

      scope.where(user_id: current_user.id)
    end

    def ensure_visible_recipe_param!(message)
      recipe_id = params.dig(:user_recipe_like, :recipe_id)
      return true if recipe_id.blank? || visible_recipes_relation.where(id: recipe_id).exists?

      render_error(message, details: { recipe_id: [ "contains an invalid value" ] })
      false
    end

    def set_user_recipe_like
      @user_recipe_like = user_recipe_likes_scope.find_by(id: params[:id])
      return if @user_recipe_like

      render_error("Recipe like not found", status: :not_found)
    end

    def user_recipe_like_params
      params.require(:user_recipe_like).permit(:recipe_id)
    end

    def normalized_errors(record)
      details = record.errors.to_hash
      details[:recipe_id] = [ "contains an invalid value" ] if details.delete(:recipe) == [ "must exist" ]
      details
    end
  end
end
