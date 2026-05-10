module Api
  class UsersController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :require_staff!, only: :create
    before_action :set_user, only: [ :show, :update, :destroy ]
    before_action :authorize_user_modification!, only: [ :update, :destroy ]

    def index
      users = User.includes(:allergies).order(:username)

      render_success({ users: users.map { |user| serialize_user(user) } })
    end

    def show
      render_success({ user: serialize_user(@user) })
    end

    def create
      user = User.new(permitted_user_params)

      if user.save
        render_success({ user: serialize_user(user) }, status: :created)
      else
        render_error("User creation failed", details: user.errors.to_hash)
      end
    rescue ActiveRecord::RecordNotFound
      render_error("User creation failed", details: { allergy_ids: [ "contain invalid values" ] })
    end

    def update
      if @user.update(permitted_user_params)
        render_success({ user: serialize_user(@user) })
      else
        render_error("User update failed", details: @user.errors.to_hash)
      end
    rescue ActiveRecord::RecordNotFound
      render_error("User update failed", details: { allergy_ids: [ "contain invalid values" ] })
    end

    def destroy
      @user.destroy
      render_success({ message: "User deleted" })
    end

    private

    def authorize_user_modification!
      return if current_user == @user || current_user&.admin?

      render_forbidden
    end

    def serialize_user(user)
      UserSerializer.render(user, viewer: current_user)
    end

    def set_user
      @user = User.includes(:allergies).find_by(id: params[:id])
      return if @user

      render_error("User not found", status: :not_found)
    end

    def permitted_user_params
      allowed_attributes = [
        :username,
        :email,
        :password,
        :password_confirmation,
        :bio,
        :profile_image_url,
        :language,
        :private_profile,
        :notifications_enabled
      ]

      allowed_attributes << { allergy_ids: [] }
      allowed_attributes.concat([ :account_status, :role ]) if current_user&.admin?

      params.require(:user).permit(*allowed_attributes)
    end
  end
end
