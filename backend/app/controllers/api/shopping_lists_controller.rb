module Api
  class ShoppingListsController < BaseController
    before_action :set_shopping_list, only: [ :show, :update, :destroy ]

    def index
      shopping_lists = ShoppingList.includes(:user, :shopping_list_items).order(:name)

      render_success({ shopping_lists: shopping_lists.map { |shopping_list| ShoppingListSerializer.render(shopping_list) } })
    end

    def show
      render_success({ shopping_list: ShoppingListSerializer.render(@shopping_list) })
    end

    def create
      shopping_list = ShoppingList.new(shopping_list_params)

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

    def set_shopping_list
      @shopping_list = ShoppingList.includes(:user, :shopping_list_items).find_by(id: params[:id])
      return if @shopping_list

      render_error("Shopping list not found", status: :not_found)
    end

    def shopping_list_params
      params.require(:shopping_list).permit(:name, :optional_description, :user_id)
    end

    def normalized_shopping_list_errors(shopping_list)
      details = shopping_list.errors.to_hash

      if details.delete(:user) == [ "must exist" ]
        details[:user_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
