class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.decimal :total, precision: 8, scale: 2
      t.string :pay_type
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
