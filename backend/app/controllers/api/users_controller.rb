module Api
  class UsersController < BaseController
    before_action :set_user, only: [ :show, :update, :destroy ]

    def index
      users = User.includes(:allergies).order(:username)

      render_success({ users: users.map { |user| UserSerializer.render(user) } })
    end

    def show
      render_success({ user: UserSerializer.render(@user) })
    end

    def create
      user = User.new(user_params)

      if user.save
        render_success({ user: UserSerializer.render(user) }, status: :created)
      else
        render_error("User creation failed", details: user.errors.to_hash)
      end
    rescue ActiveRecord::RecordNotFound
      render_error("User creation failed", details: { allergy_ids: [ "contain invalid values" ] })
    end

    def update
      if @user.update(user_params)
        render_success({ user: UserSerializer.render(@user) })
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

    def set_user
      @user = User.includes(:allergies).find_by(id: params[:id])
      return if @user

      render_error("User not found", status: :not_found)
    end

    def user_params
      params.require(:user).permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :bio,
        :profile_image_url,
        :language,
        :private_profile,
        :notifications_enabled,
        :account_status,
        :role,
        allergy_ids: []
      )
    end
  end
end
