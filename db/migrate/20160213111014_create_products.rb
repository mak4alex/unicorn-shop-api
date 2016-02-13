class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.text :description
      t.decimal :price, precision: 8, scale: 2
      t.integer :count, default: 0
      t.references :category, index: true
      t.boolean :published

      t.timestamps null: false
    end
    add_index :products, :title, unique: true
  end
end
