class AddDefaultToPostsCommentsCount < ActiveRecord::Migration[7.0]
  def change
    change_column_default :posts, :comments_count, 0
  end
end
