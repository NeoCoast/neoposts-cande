class AddDefaultToCommentsCommentsCount < ActiveRecord::Migration[7.0]
  def change
    change_column_default :comments, :comments_count, 0
  end
end
