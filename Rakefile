task :environment do
  require './app'
end

namespace :db do
  desc "Drop db data"
  task :drop => :environment do
    Participant.destroy_all
  end

  desc "Seeds the database with some demo data"
  task :seed => :environment do
    require 'faker'
    Faker::Config.locale = :en
    if Participant.count == 0
      Participant.create!(phone_number: "0404585882")
      Participant.create!(phone_number: "0414213852")
      10.times do
        phone_number = Faker::PhoneNumber.phone_number
        puts "Creating participant with phone number: #{phone_number}"
        Participant.create!(phone_number: phone_number)
      end
    end
  end
end