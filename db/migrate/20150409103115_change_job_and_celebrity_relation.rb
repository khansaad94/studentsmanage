class ChangeJobAndCelebrityRelation < ActiveRecord::Migration
  def self.up
    rename_column :jobs, :celeb_id, :celebrity_id
  end

  def self.down
    rename_column :jobs, :celebrity_id, :celeb_id
  end
end
