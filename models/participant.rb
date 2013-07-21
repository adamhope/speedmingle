require 'mongo_mapper'
require 'factory_girl'

class Participant
  include MongoMapper::Document
  key :voted_for_by, Array
end

class EmailParticipant < Participant
  key :email, String, :unique => true
end

class SmsParticipant < Participant
  key :phone_number, String, :unique => true
end