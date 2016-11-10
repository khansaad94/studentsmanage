class AddVerifyCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :code_verify, :boolean, :default => false
    user = User.where(:user_type => "celebrity")
    user.each do |user|
      user.code_verify = true
      user.save!
    end

  end
end
