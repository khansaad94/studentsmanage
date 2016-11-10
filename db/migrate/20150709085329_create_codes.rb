class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :code_name
      t.boolean :is_consumed, :default => false
      t.datetime :consumed_on
      t.string :device_token

      t.timestamps
    end
  end
end
