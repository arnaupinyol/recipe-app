module Api
  class ShoppingListsController < BaseController
    before_action :authenticate_user!
    before_action :set_shopping_list, only: [ :show, :update, :destroy ]

    def index
      shopping_lists = shopping_lists_scope.includes(:user, :shopping_list_items).order(:name)

      render_success({ shopping_lists: shopping_lists.map { |shopping_list| ShoppingListSerializer.render(shopping_list) } })
    end

    def show
      render_success({ shopping_list: ShoppingListSerializer.render(@shopping_list) })
    end

    def create
      shopping_list = current_user.shopping_lists.new(shopping_list_params)

      if shopping_list.save
        render_success({ shopping_list: ShoppingListSerializer.render(shopping_list) }, status: :created)
      else
        render_error("Shopping list creation failed", details: normalized_shopping_list_errors(shopping_list))
      end
    end

    def update
      if @shopping_list.update(shopping_list_params)
        render_success({ shopping_list: ShoppingListSerializer.render(@shopping_list) })
      else
        render_error("Shopping list update failed", details: normalized_shopping_list_errors(@shopping_list))
      end
    end

    def destroy
      @shopping_list.destroy
      render_success({ message: "Shopping list deleted" })
    end

    private

    def shopping_lists_scope
      return ShoppingList.all if current_user.admin?

      current_user.shopping_lists
    end

    def set_shopping_list
      @shopping_list = shopping_lists_scope.includes(:user, :shopping_list_items).find_by(id: params[:id])
      return if @shopping_list

      render_error("Shopping list not found", status: :not_found)
    end

    def shopping_list_params
      params.require(:shopping_list).permit(:name, :optional_description)
    end

    def normalized_shopping_list_errors(shopping_list)
      shopping_list.errors.to_hash
    end
  end
end
