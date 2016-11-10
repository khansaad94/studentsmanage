class ChangeCustomerJobId < ActiveRecord::Migration
  def change
    change_column :jobs, :customer_job_id, :string, :null => true
  end
end
