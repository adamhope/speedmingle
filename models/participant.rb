require 'mongo_mapper'

class Participant
  include MongoMapper::Document
  
  key :voted_for_by, Array
  key :phone_number, String, unique: true, required: true
  key :pin, String, unique: true, required: true
  before_create :generate_pin
  before_create ->{self.pin = generate_pin}

  def score
    voted_for_by.length
  end

  def generate_pin
    Random.rand(9).to_s + ("%03d" % Participant.count).to_s
  end
end