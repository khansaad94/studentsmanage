# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#puts "Deleting existing roles..."
#roles = Role.all
#roles.each { |role| role.destroy } if roles.present?
#
#puts "Adding default roles"
#%w(admin user celebrity).each do |name|
#  Role.create(:title => name)
#end

puts "Deleting existing users..."
user = User.where(:email => "admin@celebvidy.com").first
user.destroy if user.present?

#user = User.where(:email => "admin@adoorn.com")
#user.destroy  if user.present?
# add admin

puts "adding Celebvidy Admin"
#role = Role.where(:title => "admin").first
user = User.new(:email => "admin@studentsmanage.com",
                :password => "tudentsmanage2016",
                :first_name => "admin",
                :last_name => "admin",
                :user_type => "admin",
                :is_admin => true,
                :user_type => "admin",
)
#user.skip_confirmation!
if user.save
  puts "333333333333333333333333333333333333"
  result = Braintree::Customer.create(
      :first_name => user.first_name.present? ? user.first_name : "",
      :last_name => user.last_name.present? ? user.last_name : "",
      :email => user.email
  )
  # puts "----------Brain tree result----------", result.inspect
  if result.success?
    puts "Braintree user successfully created", result.inspect
    user.update_attributes(:customer_id => result.customer.id)
    #return true
  else
    puts "Braintree user not created", result.inspect
    # puts "---------brain tree ustomer create error-----------", result.errors
    #return false
  end
end
#user.role = role
puts "Adding default events types"
%w(Birthday Anniversary Congrats Question Other).each do |name|
  EventType.create(:name => name)
  end
#end

#rails g model Job message_for:string pronounce_like:string message_type:string message_details:text deadline:datetime celeb_id:string event_type_id:integer status:boolean video_url:string delivery_date:datetime customer_job_id:string user:references