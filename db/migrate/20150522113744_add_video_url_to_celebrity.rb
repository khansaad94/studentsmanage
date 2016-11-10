class AddVideoUrlToCelebrity < ActiveRecord::Migration
  def change
    add_column :celebrities, :video_url, :string
  end
end
