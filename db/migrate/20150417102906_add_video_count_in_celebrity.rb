class AddVideoCountInCelebrity < ActiveRecord::Migration

  def change
    add_column :celebrities, :monthly_videos, :integer
    add_column :celebrities, :default_delivery_days, :integer
  end

end
