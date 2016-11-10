class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :street_address
      t.string :city
      t.string :state
      t.integer :zip_code
      t.string :phone
      t.references :user, index: true

      t.timestamps
    end
  end
end
