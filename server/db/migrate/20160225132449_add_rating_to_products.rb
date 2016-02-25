class AddRatingToProducts < ActiveRecord::Migration
  def change
    add_column :products, :rating, :decimal, precision: 4, scale: 2
  end
end
