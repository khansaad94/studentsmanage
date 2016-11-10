class AddingVideoAttachementInJob < ActiveRecord::Migration
  def self.up
    add_attachment :jobs, :video
  end

  def self.down
    remove_attachment :jobs, :video
  end
end
