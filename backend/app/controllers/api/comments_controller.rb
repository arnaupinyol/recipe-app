module Api
  class CommentsController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :set_comment, only: [ :show, :update, :destroy ]
    before_action :authorize_comment_modification!, only: [ :update, :destroy ]

    def index
      comments = Comment.includes(:user, :recipe).joins(:recipe).merge(visible_recipes_relation).order(created_at: :desc)

      render_success({ comments: comments.map { |comment| CommentSerializer.render(comment) } })
    end

    def show
      render_success({ comment: CommentSerializer.render(@comment) })
    end

    def create
      return unless ensure_visible_recipe_param!("Comment creation failed")

      comment = current_user.comments.new(comment_params)

      if comment.save
        render_success({ comment: CommentSerializer.render(comment) }, status: :created)
      else
        render_error("Comment creation failed", details: normalized_comment_errors(comment))
      end
    end

    def update
      return unless ensure_visible_recipe_param!("Comment update failed")

      if @comment.update(comment_params)
        render_success({ comment: CommentSerializer.render(@comment) })
      else
        render_error("Comment update failed", details: normalized_comment_errors(@comment))
      end
    end

    def destroy
      @comment.destroy
      render_success({ message: "Comment deleted" })
    end

    private

    def authorize_comment_modification!
      return if current_user&.admin? || @comment.user_id == current_user.id

      render_forbidden
    end

    def ensure_visible_recipe_param!(message)
      recipe_id = params.dig(:comment, :recipe_id)
      return true if recipe_id.blank? || visible_recipes_relation.where(id: recipe_id).exists?

      render_error(message, details: { recipe_id: [ "contains an invalid value" ] })
      false
    end

    def set_comment
      @comment = Comment.includes(:user, :recipe).joins(:recipe).merge(visible_recipes_relation).find_by(id: params[:id])
      return if @comment

      render_error("Comment not found", status: :not_found)
    end

    def comment_params
      params.require(:comment).permit(:text, :rating, :recipe_id)
    end

    def normalized_comment_errors(comment)
      details = comment.errors.to_hash

      if details.delete(:recipe) == [ "must exist" ]
        details[:recipe_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
