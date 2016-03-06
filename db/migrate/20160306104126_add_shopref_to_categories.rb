class AddShoprefToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :shop, index: true, foreign_key: true
  end
end
