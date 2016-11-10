class CreateCelebrities < ActiveRecord::Migration
  def change
    create_table :celebrities do |t|
      t.string :about_me, null: false
      t.text :description, null: false
      t.float :default_rate, null: false
      t.float :per_alphabet_rate, null: false
      t.boolean :verified_account, :null => false, :default => false
      t.datetime :date_of_birth
      t.text :fb_link
      t.text :tw_link
      t.text :pin_link
      t.text :gmail_link
      t.text :sn_link
      t.text :in_link
      t.references :user
      t.timestamps
    end
  end
end
