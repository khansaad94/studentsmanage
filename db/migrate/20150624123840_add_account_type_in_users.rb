class AddAccountTypeInUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_type, :string, :default => "personal"

  end
end
