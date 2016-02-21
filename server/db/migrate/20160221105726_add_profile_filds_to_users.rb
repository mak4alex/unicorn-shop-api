class AddProfileFildsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :sex, :string
    add_column :users, :phone, :string
    add_column :users, :country, :string
    add_column :users, :city, :string
    add_column :users, :address, :string
    add_column :users, :birthday, :date
  end
end
