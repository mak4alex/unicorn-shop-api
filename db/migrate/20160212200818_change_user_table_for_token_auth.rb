class ChangeUserTableForTokenAuth < ActiveRecord::Migration
  def change
    add_column :users, :reset_password_redirect_url, :string
    add_column :users, :provider, :string
    add_column :users, :uid, :string, null: false, default: ''
    add_column :users, :tokens, :text
    add_index :users, :uid, :unique => true
  end
end
