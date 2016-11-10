class CreateTransactionHistories < ActiveRecord::Migration
  def change
    create_table :transaction_histories do |t|
      t.string :transaction_id
      t.string :status
      t.string :transaction_type
      t.decimal :transaction_amount
      t.decimal :braintree_fee_amount
      t.decimal :celebvidy_fee_amount
      t.string :merchant_id
      t.string :customer_id
      t.integer :user_id
      t.decimal :price
      t.integer :job_id
      t.timestamps
    end
  end
end
