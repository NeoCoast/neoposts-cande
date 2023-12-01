class AddCommentsCountToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :comments_count, :integer
    Comment.find_each { |comment| Comment.reset_counters(comment.id, :comments) }
  end
end
