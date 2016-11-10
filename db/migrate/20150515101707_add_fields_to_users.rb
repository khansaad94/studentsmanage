class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :push_notification, :boolean
    add_column :users, :away_mode, :boolean
  end
end
