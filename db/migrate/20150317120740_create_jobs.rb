class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :message_for, null: false
      t.string :pronounce_like, null: false
      t.boolean :is_gift
      t.text :message_details, null: false
      t.datetime :deadline
      t.integer :celeb_id, null: false
      t.integer :event_type_id, null: false
      t.string :status
      t.string :video_url
      t.datetime :delivery_date
      t.string :customer_job_id, null: false
      t.references :user, index: true

      t.timestamps
    end
  end
end
