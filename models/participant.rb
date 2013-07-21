require 'mongo_mapper'
require 'factory_girl'

class Participant
  include MongoMapper::Document

  key :voted_for_by, Array
end

class EmailParticipant < Participant
  key :email, String
end

class SmsParticipant < Participant
  key :phone_number, String
end