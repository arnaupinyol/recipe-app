class CommentSerializer
  def self.render(comment)
    {
      id: comment.id,
      text: comment.text,
      rating: comment.rating,
      user_id: comment.user_id,
      username: comment.user.username,
      recipe_id: comment.recipe_id,
      recipe_title: comment.recipe.title,
      created_at: comment.created_at,
      updated_at: comment.updated_at
    }
  end
end
