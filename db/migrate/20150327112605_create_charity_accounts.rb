class CreateCharityAccounts < ActiveRecord::Migration
  def change
    create_table :charity_accounts do |t|
      t.string :name
      t.string :merchant_id
      t.timestamps
    end
  end
end
