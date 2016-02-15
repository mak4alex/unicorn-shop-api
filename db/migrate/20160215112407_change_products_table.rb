class ChangeProductsTable < ActiveRecord::Migration
  def change
    remove_column :products, :count, :integer, default: 0
    add_column :products, :quantity, :integer, default: 0
    add_column :products, :weight, :decimal, default: 0.0, precision: 6, scale: 3
  end
end
