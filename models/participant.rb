require 'mongo_mapper'

class Participant
  include MongoMapper::Document
  
  key :connected_to_ids, Array
  key :phone_number, String, unique: true, required: true
  key :pin, String, unique: true
  before_create ->{self.pin = generate_pin}

  def score
    connected_to_ids.length
  end

  def generate_pin
    Random.rand(9).to_s + ("%03d" % Participant.count).to_s
  end

  def connect_to(participant)
    self.push_uniq(connected_to_ids: participant.id)
    self.reload
  end
end