class CategorySerializer
  def self.render(category)
    {
      id: category.id,
      name: category.name,
      description: category.description,
      image_url: AttachmentUrlHelper.url_for(category.image),
      created_at: category.created_at,
      updated_at: category.updated_at
    }
  end
end
