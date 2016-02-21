class AddDiscountToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :discount, index: true, foreign_key: true
  end
end
