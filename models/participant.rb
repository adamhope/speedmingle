require 'mongo_mapper'

class Participant
  include MongoMapper::Document
  
  key :phone_number, String, unique: true, required: true
  key :username, String, unique: true #, required: true TODO will be require!
  key :pin, String, unique: true
  key :connected_to_ids, Array
  before_create ->{self.pin = generate_pin}

  def score
    connected_to_ids.length
  end

  def generate_pin
    Random.rand(9).to_s + ("%03d" % Participant.count).to_s
  end

  def connect_from(participant)
    self.push_uniq(connected_to_ids: participant.id)
    self.reload
  end
end