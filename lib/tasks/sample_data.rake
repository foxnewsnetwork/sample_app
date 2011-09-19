namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:username => "Example User" , 
                :email => "example@example.org" ,
                :password => "foobar" ,
                :password_confirmation => "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.org"
      password = "password"
      User.create!(:username => name ,
                  :email => email ,
                  :password => password ,
                  :password_confirmation => password)
    end
    
    50.times do
      User.all(:limit => 6).each do |user|
        user.macroposts.create!(:title => Faker::Lorem.sentence(2) ,
                                :content => Faker::Lorem.sentence(5) ,
                                :location_id => 1 )
      end
    end
  end
end
