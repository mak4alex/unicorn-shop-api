class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.text :description
      t.timestamps null: false
    end
    add_index :categories, :title, unique: true
  end
end
