module Api
  class UtensilsController < BaseController
    before_action :set_utensil, only: [ :show, :update, :destroy ]

    def index
      utensils = Utensil.includes(:recipes).order(:name)

      render_success({ utensils: utensils.map { |utensil| UtensilSerializer.render(utensil) } })
    end

    def show
      render_success({ utensil: UtensilSerializer.render(@utensil) })
    end

    def create
      utensil = Utensil.new(utensil_params)

      if utensil.save
        render_success({ utensil: UtensilSerializer.render(utensil) }, status: :created)
      else
        render_error("Utensil creation failed", details: utensil.errors.to_hash)
      end
    rescue ActiveRecord::RecordNotFound
      render_error("Utensil creation failed", details: { recipe_ids: [ "contain invalid values" ] })
    end

    def update
      if @utensil.update(utensil_params)
        render_success({ utensil: UtensilSerializer.render(@utensil) })
      else
        render_error("Utensil update failed", details: @utensil.errors.to_hash)
      end
    rescue ActiveRecord::RecordNotFound
      render_error("Utensil update failed", details: { recipe_ids: [ "contain invalid values" ] })
    end

    def destroy
      if @utensil.recipes.exists?
        return render_error("Utensil cannot be deleted because it is associated with recipes", status: :conflict)
      end

      @utensil.destroy
      render_success({ message: "Utensil deleted" })
    end

    private

    def set_utensil
      @utensil = Utensil.includes(:recipes).find_by(id: params[:id])
      return if @utensil

      render_error("Utensil not found", status: :not_found)
    end

    def utensil_params
      params.require(:utensil).permit(:name, recipe_ids: [])
    end
  end
end
