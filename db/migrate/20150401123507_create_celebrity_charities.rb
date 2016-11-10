class CreateCelebrityCharities < ActiveRecord::Migration
  def change
    create_table :celebrity_charities do |t|
      t.float :charity_percentage, null: false
      t.references :celebrity
      t.references :charity_account
      t.timestamps
    end
  end
end
