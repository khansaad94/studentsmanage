class ChangeDefaultTypeInUsers < ActiveRecord::Migration
  def change
    change_column :users, :account_type, :string, :default => "Personal Account"
  end
end
