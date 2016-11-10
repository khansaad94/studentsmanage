class CreatePaymentAddresses < ActiveRecord::Migration
  def change
    create_table :payment_addresses do |t|
      t.string :legal_name
      t.string :address
      t.string :city
      t.string :state
      t.integer :zip_code
      t.references :celebrity, index: true

      t.timestamps
    end
  end
end
