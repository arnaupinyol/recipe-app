module Api
  class ShoppingListItemsController < BaseController
    before_action :authenticate_user!
    before_action :set_shopping_list_item, only: [ :show, :update, :destroy ]

    def index
      shopping_list_items = shopping_list_items_scope.order(:id)

      render_success({ shopping_list_items: shopping_list_items.map { |item| ShoppingListItemSerializer.render(item) } })
    end

    def show
      render_success({ shopping_list_item: ShoppingListItemSerializer.render(@shopping_list_item) })
    end

    def create
      return unless ensure_accessible_shopping_list!("Shopping list item creation failed")

      shopping_list_item = ShoppingListItem.new(shopping_list_item_params)

      if shopping_list_item.save
        render_success({ shopping_list_item: ShoppingListItemSerializer.render(shopping_list_item) }, status: :created)
      else
        render_error("Shopping list item creation failed", details: normalized_shopping_list_item_errors(shopping_list_item))
      end
    end

    def update
      return unless ensure_accessible_shopping_list!("Shopping list item update failed")

      if @shopping_list_item.update(shopping_list_item_params)
        render_success({ shopping_list_item: ShoppingListItemSerializer.render(@shopping_list_item) })
      else
        render_error("Shopping list item update failed", details: normalized_shopping_list_item_errors(@shopping_list_item))
      end
    end

    def destroy
      @shopping_list_item.destroy
      render_success({ message: "Shopping list item deleted" })
    end

    private

    def shopping_list_items_scope
      scope = ShoppingListItem.includes(:ingredient, :shopping_list)
      return scope if current_user.admin?

      scope.joins(:shopping_list).where(shopping_lists: { user_id: current_user.id })
    end

    def accessible_shopping_lists_scope
      return ShoppingList.all if current_user.admin?

      current_user.shopping_lists
    end

    def ensure_accessible_shopping_list!(message)
      shopping_list_id = params.dig(:shopping_list_item, :shopping_list_id)
      return true if shopping_list_id.blank? || accessible_shopping_lists_scope.where(id: shopping_list_id).exists?

      render_error(message, details: { shopping_list_id: [ "contains an invalid value" ] })
      false
    end

    def set_shopping_list_item
      @shopping_list_item = shopping_list_items_scope.find_by(id: params[:id])
      return if @shopping_list_item

      render_error("Shopping list item not found", status: :not_found)
    end

    def shopping_list_item_params
      params.require(:shopping_list_item).permit(:shopping_list_id, :ingredient_id, :quantity, :unit_type, :purchased)
    end

    def normalized_shopping_list_item_errors(shopping_list_item)
      details = shopping_list_item.errors.to_hash

      if details.delete(:ingredient) == [ "must exist" ]
        details[:ingredient_id] = [ "contains an invalid value" ]
      end

      if details.delete(:shopping_list) == [ "must exist" ]
        details[:shopping_list_id] = [ "contains an invalid value" ]
      end

      details
    end
  end
end
