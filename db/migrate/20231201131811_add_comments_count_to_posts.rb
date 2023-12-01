class AddCommentsCountToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :comments_count, :integer
    Post.find_each { |post| Post.reset_counters(post.id, :comments) }
  end
end
