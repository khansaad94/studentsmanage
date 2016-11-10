namespace :db do

  task :seed_full_name => :environment do

    user = User.all

    user.each do |usr|

      if usr.full_name.blank?
        if (usr.first_name.present? && usr.last_name.present?)
        fu_name = usr.first_name + " " + usr.last_name
        usr.update_attributes(:full_name => fu_name)
          end

      end

    end


  end

end