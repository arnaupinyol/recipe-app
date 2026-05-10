module Api
  class AllergiesController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :require_staff!, only: [ :create, :update, :destroy ]
    before_action :set_allergy, only: [ :show, :update, :destroy ]

    def index
      allergies = Allergy.includes(:ingredients).order(:name)

      render_success({ allergies: allergies.map { |allergy| AllergySerializer.render(allergy) } })
    end

    def show
      render_success({ allergy: AllergySerializer.render(@allergy) })
    end

    def create
      allergy = Allergy.new(allergy_params)

      if allergy.save
        render_success({ allergy: AllergySerializer.render(allergy) }, status: :created)
      else
        render_error("Allergy creation failed", details: allergy.errors.to_hash)
      end
    end

    def update
      if @allergy.update(allergy_params)
        render_success({ allergy: AllergySerializer.render(@allergy) })
      else
        render_error("Allergy update failed", details: @allergy.errors.to_hash)
      end
    end

    def destroy
      if @allergy.ingredients.exists? || @allergy.users.exists?
        return render_error("Allergy cannot be deleted because it is associated with ingredients or users", status: :conflict)
      end

      @allergy.destroy
      render_success({ message: "Allergy deleted" })
    end

    private

    def set_allergy
      @allergy = Allergy.includes(:ingredients).find_by(id: params[:id])
      return if @allergy

      render_error("Allergy not found", status: :not_found)
    end

    def allergy_params
      params.require(:allergy).permit(:name, ingredient_ids: [])
    end
  end
end
