require 'mongo_mapper'

class Participant
  include MongoMapper::Document
  
  key :phone_number, String, unique: true, required: true
  key :username, String, unique: true, required: true
  key :pin, String, unique: true
  key :connected_to_ids, Array
  before_create ->{self.pin = generate_pin}


  def self.to_filtered_json(obj)
    obj.to_json(except: [:phone_number, :pin])
  end

  def score
    connected_to_ids.length
  end

  def self.rank
    Participant.all.sort_by(&:score).reverse
  end

  def generate_pin
    Random.rand(9).to_s + ("%03d" % Participant.count).to_s
  end

  def connect_from(participant)
    self.push_uniq(connected_to_ids: participant.id)
    self.reload
  end

  def self.links 
    nodes = Participant.all.map { |p| { id: p.phone_number, name: p.username, size: p.score }}
    links = Participant.all.map do |p| 
      p.connected_to_ids.map do |v|
        voter_phone_number = Participant.where(id: v).first.phone_number
        if nodes.any? { |p| p[:id] == voter_phone_number }
          { source: voter_phone_number, target: p.phone_number } 
        end
      end 
    end
    { nodes: nodes, links: links, totalDonation: 10,  nodeCount: 0, linkCount: 315 }
  end
end