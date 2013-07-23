task :environment do
  require './app'
end

namespace :db do
  desc "Seeds the database with some demo data"
  task :seed => :environment do
    EmailParticipant.create!(:email => "dom@dom.com")
    EmailParticipant.create!(:email => "dom1@dom1.com")
  end
end