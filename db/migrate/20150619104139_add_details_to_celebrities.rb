class AddDetailsToCelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :is_video_verified, :boolean, :default => false
  end
end
