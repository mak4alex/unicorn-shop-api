class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :title
      t.integer :percent

      t.timestamps null: false
    end
  end
end
