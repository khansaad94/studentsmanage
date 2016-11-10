  task :update_inventory => :environment do
    if Date.today.day == 1
   user = User.where(:user_type => "celebrity").all
   user.each do |user|
   if user.celebrity.present?
   videos = user.celebrity.monthly_videos.to_i + 100
   if videos > 500
     videos = 500
   end
   user.celebrity.update_attribute("monthly_videos", videos)
   end
   end
      end
  end

