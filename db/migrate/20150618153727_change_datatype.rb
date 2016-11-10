class ChangeDatatype < ActiveRecord::Migration
  def change
    remove_column :payment_addresses , :zip_code
    add_column :payment_addresses , :zip_code, :string
  end
end
