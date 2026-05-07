module Api
  class CommentsController < BaseController
    before_action :set_comment, only: [ :show, :update, :destroy ]

    def index
      comments = Comment.includes(:user, :recipe).order(created_at: :desc)

      render_success({ comments: comments.map { |comment| CommentSerializer.render(comment) } })
    end

    def show
      render_success({ comment: CommentSerializer.render(@comment) })
    end

    def create
      comment = Comment.new(comment_params)

      if comment.save
        render_success({ comment: CommentSerializer.render(comment) }, status: :created)
      else
        render_error("Comment creation failed", details: normalized_comment_errors(comment))
      end
    end

    def update
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

    def set_comment
      @comment = Comment.includes(:user, :recipe).find_by(id: params[:id])
      return if @comment

      render_error("Comment not found", status: :not_found)
    end

    def comment_params
      params.require(:comment).permit(:text, :rating, :user_id, :recipe_id)
    end

    def normalized_comment_errors(comment)
      details = comment.errors.to_hash

      if details.delete(:user) == [ "must exist" ]
        details[:user_id] = [ "contains an invalid value" ]
      end

      if details.delete(:recipe) == [ "must exist" ]
        details[:recipe_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
