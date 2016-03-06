class AddSubCategoriesToCategories < ActiveRecord::Migration
  def change
    add_reference :categories, :parent_category, index: true, foreign_key: true
  end
end
