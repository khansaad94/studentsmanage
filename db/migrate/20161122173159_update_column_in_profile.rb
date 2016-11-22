class UpdateColumnInProfile < ActiveRecord::Migration
  def change
    change_column :profiles, :is_approved, :boolean, :default => false

  end
end
