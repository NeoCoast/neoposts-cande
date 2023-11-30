class AddAuthColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""
      t.json :tokens
    end
  end
end
