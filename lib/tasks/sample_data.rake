require 'faker'

namespace :db do 
  desc "Fill database with sample data" 
  task :populate => :environment do
    Rake::Task['db:reset'].invoke 
    admin = User.create!(:name => "My Example",
                 :email => "fake@example.com", 
                 :password => "password", 
                 :password_confirmation => "password")
    admin.toggle!(:admin)
    99.times do |n| 
      name = Faker::Name.name 
      email = "example-#{n+1}@railstutorial.org" 
      password = "password" 
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password)
    end
    
    User.all(:limit => 6).each do |user|
      50.times do 
        user.recipes.create!(:instructions => Faker::Lorem.sentence(5))
      end 
    end
  end
  
  
end