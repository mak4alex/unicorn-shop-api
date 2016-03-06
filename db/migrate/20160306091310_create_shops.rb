class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :title
      t.string :register_number

      t.timestamps null: false
    end
    add_index :shops, :title,           unique: true
    add_index :shops, :register_number, unique: true
  end
end
