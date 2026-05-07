class ShoppingListSerializer
  def self.render(shopping_list)
    {
      id: shopping_list.id,
      name: shopping_list.name,
      optional_description: shopping_list.optional_description,
      user_id: shopping_list.user_id,
      username: shopping_list.user.username,
      shopping_list_item_ids: shopping_list.shopping_list_items.order(:id).pluck(:id),
      items_count: shopping_list.shopping_list_items.size,
      created_at: shopping_list.created_at,
      updated_at: shopping_list.updated_at
    }
  end
end
