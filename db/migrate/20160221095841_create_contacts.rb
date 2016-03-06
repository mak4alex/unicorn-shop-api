class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :email
      t.string :name
      t.string :phone
      t.string :country
      t.string :city
      t.string :address
      t.string :comment

      t.timestamps null: false
    end
  end
end
