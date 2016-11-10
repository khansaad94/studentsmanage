class AddFieldsTocelebrities < ActiveRecord::Migration
  def change
    add_column :celebrities, :charity_rate, :float
  end
end
