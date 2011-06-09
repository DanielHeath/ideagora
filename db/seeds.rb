# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

rc9 = Camp.find_by_name('Railscamp 9') || Camp.create(:name => 'Railscamp 9', :location => 'Lake Ainsworth, Lennox Head, NSW', :current => true, :time_zone => 'Sydney', :start_at => '2011-06-10 16:00:00', :end_at => '2011-06-13 10:00:00')

['Library', 'Lake View Conference Room - North', 'Lake View Conference Room - South'].each { |v| rc9.venues.create!(:name => v) unless rc9.venues.find_by_name(v) }

#create discussion for talks page
Discussion.create :camp_id => rc9.id, :title => 'Share ideas and requests for talks', :path => '/talks'

require 'csv'
filename = File.join(Rails.root.to_s, 'db', 'seeds', 'rc9_attendees.csv')
puts "Making sure we have some users for #{rc9.name}..."
CSV.foreach(filename, :headers => true) do |row|
  if rc9.users.find_by_email(row['email']).nil?
    puts "Creating #{row['first_name']} #{row['last_name']}"
    u = rc9.users.create!(
      :first_name => row['first_name'],
      :last_name => row['last_name'],
      :email => row['email'],
      :twitter => row['twitter']
    )
  end
end
puts "Done with users."


%w(ben@hoskings.net
ellemeredith@gmail.com
gabe@avantbard.com
jason@codespike.com
jason.stirk@rubyx.com
kpitty@cockatoosoftware.com.au
scottandrewharvey@gmail.com
tim@mcewan.it
zubin@wickedweasel.com).each do |email|
  puts "Setting #{email} as organiser"
  User.find_by_email!(email).attendances.first.update_attribute(:organiser, true)
end
puts 'Done with organisers.'

content = <<-EOS
Food on arrival: For those who arrive on the bus or other means by about 2:30 pm, there will be a welcome BBQ by the lake. The first main meal will be served in the dining hall at 6:30 pm.

Registration: From 4 pm the registration desk will be open so that you can let us know you've arrived, collect your lanyard as well as t-shirt and other schwag. Please make sure you register as soon as you can after 4 pm.

Meal Times: Breakfast: 7:30 - 8:00 am; Lunch: 12:00 - 1:00 pm; Dinner: 6:30 - 7:30 pm

Coffee: Available from Saturday morning onwards.

Beer: Available from Friday evening onwards to those who purchased VIP tickets (a limited number of cash upgrades will be available).
EOS

u = User.find_by_email!('kpitty@cockatoosoftware.com.au')
Notice.create!(:title => 'Welcome to Lake Ainsworth', :content => content, :camp => rc9, :user => u)

#fake some talks
# venues = rc9.venues
# users = rc9.users
# rc9.talk_days.each do |day|
#   rc9.talk_hours.each do |hour|
#     next if hour % 3 == 0 #skip some talk slots
# 
#     venue = venues[hour % venues.length]
#     speaker = users[hour % users.length]
# 
#     start_at = day + hour.hours
#     talk = Talk.create!(
#       :venue_id => venue.id,
#       :user_id => speaker.id,
#       :name => Faker::Company.catch_phrase,
#       :start_at => start_at,
#       :end_at => start_at + 1.hour
#     )
#     puts "Created talk #{talk.name}"
#   end
# end

