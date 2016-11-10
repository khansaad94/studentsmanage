class AddDetailsToPaymentAddresses < ActiveRecord::Migration
  def change
    add_column :payment_addresses, :mail_to_name, :string
  end
end
