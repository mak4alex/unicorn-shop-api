class AddContactToOrders < ActiveRecord::Migration
  def change
    add_reference :contacts, :order, index: true, foreign_key: true
  end
end
