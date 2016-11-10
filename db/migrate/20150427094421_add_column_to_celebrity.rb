class AddColumnToCelebrity < ActiveRecord::Migration
  def change
      add_column :celebrities, :additional_monthly_videos, :integer
  end
end
