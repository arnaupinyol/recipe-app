module Api
  class FollowsController < BaseController
    before_action :authenticate_user!
    before_action :set_follow, only: [ :show, :update, :destroy ]

    def index
      follows = follows_scope.order(followed_at: :desc)

      render_success({ follows: follows.map { |follow| FollowSerializer.render(follow) } })
    end

    def show
      render_success({ follow: FollowSerializer.render(@follow) })
    end

    def create
      follow = current_user.follows_as_follower.new(follow_params)

      if follow.save
        render_success({ follow: FollowSerializer.render(follow) }, status: :created)
      else
        render_error("Follow creation failed", details: normalized_errors(follow))
      end
    end

    def update
      if @follow.update(follow_params)
        render_success({ follow: FollowSerializer.render(@follow) })
      else
        render_error("Follow update failed", details: normalized_errors(@follow))
      end
    end

    def destroy
      @follow.destroy
      render_success({ message: "Follow deleted" })
    end

    private

    def follows_scope
      scope = Follow.includes(:follower, :followed)
      return scope if current_user.admin?

      scope.where(follower_id: current_user.id)
    end

    def set_follow
      @follow = follows_scope.find_by(id: params[:id])
      return if @follow

      render_error("Follow not found", status: :not_found)
    end

    def follow_params
      params.require(:follow).permit(:followed_id)
    end

    def normalized_errors(record)
      details = record.errors.to_hash
      details[:followed_id] = [ "contains an invalid value" ] if details.delete(:followed) == [ "must exist" ]
      details
    end
  end
end
