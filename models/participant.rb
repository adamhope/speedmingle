require 'mongo_mapper'

class Participant
  include MongoMapper::Document
  
  key :phone_number, String, unique: true, required: true
  key :username, String, unique: true, required: true
  key :pin, String, unique: true
  key :connected_to_ids, Array
  before_create ->{self.pin = generate_pin}

  # def  serializable_hash(options = {})
  #   super({ only: [:id, :username, :connected_to_ids] }.merge(options))
  # end

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

  def as_json(options={})
    super(methods: :score)
  end

  def self.links 
    nodes = Participant.all.map { |p| { id: p.id, name: p.username, size: p.score }}
    links = []
    Participant.all.each do |p|
      p.connected_to_ids.each do |v|
        links << { source: v, target: p.id } if nodes.any? { |n| n[:id] == v }
      end
    end
    { nodes: nodes, links: links, totalDonation: 10,  nodeCount: Participant.count, linkCount: links.length }
  end

  def self.bubbles
    Participant.all.map { |p| { name: p.username, score: p.score + 1, id: p.id } }
  end
end