module Api
  class CategoriesController < BaseController
    before_action :authenticate_user!, only: [ :create, :update, :destroy ]
    before_action :require_staff!, only: [ :create, :update, :destroy ]
    before_action :set_category, only: [ :show, :update, :destroy ]

    def index
      categories = Category.includes(image_attachment: :blob).order(:name)

      render_success({ categories: categories.map { |category| CategorySerializer.render(category) } })
    end

    def show
      render_success({ category: CategorySerializer.render(@category) })
    end

    def create
      category = Category.new(category_params)

      if category.save
        render_success({ category: CategorySerializer.render(category) }, status: :created)
      else
        render_error("Category creation failed", details: category.errors.to_hash)
      end
    end

    def update
      if @category.update(category_params)
        render_success({ category: CategorySerializer.render(@category) })
      else
        render_error("Category update failed", details: @category.errors.to_hash)
      end
    end

    def destroy
      if @category.recipes.exists?
        return render_error("Category cannot be deleted because it is associated with recipes", status: :conflict)
      end

      @category.destroy
      render_success({ message: "Category deleted" })
    end

    private

    def set_category
      @category = Category.includes(image_attachment: :blob).find_by(id: params[:id])
      return if @category

      render_error("Category not found", status: :not_found)
    end

    def category_params
      params.require(:category).permit(:name, :description, :image)
    end
  end
end
