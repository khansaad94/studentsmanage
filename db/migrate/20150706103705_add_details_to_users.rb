class AddDetailsToUsers < ActiveRecord::Migration
  def change

    #def up
        add_column :users, :agent_code, :string
        user = User.where(:user_type => "celebrity")
        user.each do |user|
          user.agent_code = "CELEB" + rand(12345).to_s + user.id.to_s
          user.save!
        end
      #end
      #
      #def down
      #  remove_column :users, :status
      #end

  end
end
