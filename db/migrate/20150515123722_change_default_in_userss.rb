class ChangeDefaultInUserss < ActiveRecord::Migration
  def change
    change_column_default :users, :push_notification, false
    change_column_default :users, :away_mode, false
  end
end
