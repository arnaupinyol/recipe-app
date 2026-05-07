class CategorySerializer
  def self.render(category)
    {
      id: category.id,
      name: category.name,
      description: category.description,
      created_at: category.created_at,
      updated_at: category.updated_at
    }
  end
end
