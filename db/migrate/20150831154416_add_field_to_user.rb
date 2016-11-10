class AddFieldToUser < ActiveRecord::Migration
  def change
    add_column :users, :payment_by_check, :boolean , :default => false
  end
end
