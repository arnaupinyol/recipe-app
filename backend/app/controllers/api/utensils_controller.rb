module Api
  class UtensilsController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :require_staff!, only: [ :create, :update, :destroy ]
    before_action :set_utensil, only: [ :show, :update, :destroy ]

    def index
      utensils = Utensil.includes(:recipes, image_attachment: :blob).order(:name)

      render_success({ utensils: utensils.map { |utensil| serialize_utensil(utensil) } })
    end

    def show
      render_success({ utensil: serialize_utensil(@utensil) })
    end

    def create
      utensil = Utensil.new(utensil_params)

      if utensil.save
        render_success({ utensil: serialize_utensil(utensil) }, status: :created)
      else
        render_error("Utensil creation failed", details: utensil.errors.to_hash)
      end
    end

    def update
      if @utensil.update(utensil_params)
        render_success({ utensil: serialize_utensil(@utensil) })
      else
        render_error("Utensil update failed", details: @utensil.errors.to_hash)
      end
    end

    def destroy
      if @utensil.recipes.exists?
        return render_error("Utensil cannot be deleted because it is associated with recipes", status: :conflict)
      end

      @utensil.destroy
      render_success({ message: "Utensil deleted" })
    end

    private

    def serialize_utensil(utensil)
      visible_recipes = utensil.recipes.merge(visible_recipes_relation).order(:title).to_a
      UtensilSerializer.render(utensil, recipes: visible_recipes)
    end

    def set_utensil
      @utensil = Utensil.includes(:recipes, image_attachment: :blob).find_by(id: params[:id])
      return if @utensil

      render_error("Utensil not found", status: :not_found)
    end

    def utensil_params
      params.require(:utensil).permit(:name, :image)
    end
  end
end
