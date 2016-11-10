class CreateIndustries < ActiveRecord::Migration
  def change
    create_table :industries do |t|
      t.string :title

      t.timestamps
    end
    add_column :celebrities, :industry_id, :integer
  end
end
