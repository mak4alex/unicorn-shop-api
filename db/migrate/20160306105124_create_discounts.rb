class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.decimal :initial_sum, precision: 9, scale: 2
      t.decimal :percent,     precision: 4, scale: 2
      t.references :shop, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
