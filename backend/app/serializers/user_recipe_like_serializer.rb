class UserRecipeLikeSerializer
  def self.render(like)
    {
      id: like.id,
      user_id: like.user_id,
      username: like.user.username,
      recipe_id: like.recipe_id,
      recipe_title: like.recipe.title,
      created_at: like.created_at,
      updated_at: like.updated_at
    }
  end
end
