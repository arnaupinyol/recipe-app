module Api
  class UserRecipeLikesController < BaseController
    before_action :set_user_recipe_like, only: [ :show, :update, :destroy ]

    def index
      likes = UserRecipeLike.includes(:user, :recipe).order(created_at: :desc)

      render_success({ user_recipe_likes: likes.map { |like| UserRecipeLikeSerializer.render(like) } })
    end

    def show
      render_success({ user_recipe_like: UserRecipeLikeSerializer.render(@user_recipe_like) })
    end

    def create
      like = UserRecipeLike.new(user_recipe_like_params)

      if like.save
        render_success({ user_recipe_like: UserRecipeLikeSerializer.render(like) }, status: :created)
      else
        render_error("Recipe like creation failed", details: normalized_errors(like))
      end
    end

    def update
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

    def set_user_recipe_like
      @user_recipe_like = UserRecipeLike.includes(:user, :recipe).find_by(id: params[:id])
      return if @user_recipe_like

      render_error("Recipe like not found", status: :not_found)
    end

    def user_recipe_like_params
      params.require(:user_recipe_like).permit(:user_id, :recipe_id)
    end

    def normalized_errors(record)
      details = record.errors.to_hash
      details[:user_id] = [ "contains an invalid value" ] if details.delete(:user) == [ "must exist" ]
      details[:recipe_id] = [ "contains an invalid value" ] if details.delete(:recipe) == [ "must exist" ]
      details
    end
  end
end
