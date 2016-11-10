class CreateBraintreeInfos < ActiveRecord::Migration
  def change
    create_table :braintree_infos do |t|
      t.string :customer_id
      t.string :payment_method_token
      t.string :card_type
      t.boolean :status
      t.boolean :active
      t.references :user, index: true

      t.timestamps
    end
  end
end
