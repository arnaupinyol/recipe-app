class ShoppingListItemSerializer
  def self.render(shopping_list_item)
    {
      id: shopping_list_item.id,
      shopping_list_id: shopping_list_item.shopping_list_id,
      shopping_list_name: shopping_list_item.shopping_list.name,
      ingredient_id: shopping_list_item.ingredient_id,
      ingredient_name: shopping_list_item.ingredient.name,
      quantity: shopping_list_item.quantity,
      unit_type: shopping_list_item.unit_type,
      purchased: shopping_list_item.purchased,
      created_at: shopping_list_item.created_at,
      updated_at: shopping_list_item.updated_at
    }
  end
end
