require 'mongo_mapper'

class Participant
  include MongoMapper::Document
  key :voted_for_by, Array

  def score
    voted_for_by.length
  end
end

class EmailParticipant < Participant
  key :email, String, :unique => true
end

class SmsParticipant < Participant
  key :phone_number, String, :unique => true
end