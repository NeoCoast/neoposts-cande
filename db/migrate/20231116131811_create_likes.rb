class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.references :likeable, polymorphic: true
      t.references :user
      t.timestamps
    end
  end
end
