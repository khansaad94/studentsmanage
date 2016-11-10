class UpdateCelebrityTable < ActiveRecord::Migration
  def self.up
    add_attachment :celebrities, :video
  end

  def self.down
    remove_attachment :celebrities, :video
  end
end
