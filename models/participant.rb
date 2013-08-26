require 'mongo_mapper'

class Participant
  include MongoMapper::Document
  key :voted_for_by, Array
  key :phone_number, String, :unique => true, :required => true
  def score
    voted_for_by.length
  end
end