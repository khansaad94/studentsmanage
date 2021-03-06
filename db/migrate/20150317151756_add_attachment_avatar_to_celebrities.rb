class AddAttachmentAvatarToCelebrities < ActiveRecord::Migration
  def self.up
    change_table :celebrities do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :celebrities, :avatar
  end
end
