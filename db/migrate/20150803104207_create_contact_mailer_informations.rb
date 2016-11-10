class CreateContactMailerInformations < ActiveRecord::Migration
  def change
    create_table :contact_mailer_informations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone_number
      t.string :order_number
      t.string :site_issue
      t.text :description

      t.timestamps
    end
  end
end
