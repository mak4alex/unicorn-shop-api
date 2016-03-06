class RenameDiscountTableToStock < ActiveRecord::Migration
  def change
    remove_foreign_key :products, :discounts
    remove_index :products, column: :discount_id, name: 'index_products_on_discount_id'

    rename_table :discounts, :stocks
    rename_column(:products, :discount_id, :stock_id)
    add_index :products, :stock_id
    add_foreign_key :products, :stocks
  end
end
