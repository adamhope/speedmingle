require 'spec_helper'

describe 'The participant model' do
  
  it "should create a new participant, and be returned by id" do
    participant = Participant.create!(phone_number: "0414213852", username: 'Fred')
    Participant.where(:id => participant.id).first.phone_number.should == "0414213852"
  end

  it "should return a list of participants" do
    Participant.create!(phone_number: "0414213852", username: 'Fred')
    Participant.create!(phone_number: "0404882585", username: 'Dom')
    Participant.count.should == 2
  end

  it "should delete an existing participant" do
    participant = Participant.create!(phone_number: "0414213852", username: 'Fred')
    Participant.all.length.should == 1
    participant.destroy
    Participant.count.should == 0
  end

  it 'sets a unique pin when creating' do
    participant = Participant.new(phone_number: '02020202', username: 'Fred')
    participant.pin.should be_nil
    participant.save
    participant.pin.should_not be_nil
  end

  describe '#connect_from' do
    let!(:participant_a) {Participant.create!(phone_number: '0411221122', username: 'Fred')}
    let!(:participant_b) {Participant.create!(phone_number: '0400000000', username: 'Dom')}

    it 'adds the participant if not already there' do
      participant_a.connect_from(participant_b)
      participant_a.connected_to_ids.should include(participant_b.id)
      participant_a.connected_to_ids.length.should == 1
    end

    it 'does not add participant if already there' do
      participant_a.connect_from(participant_b)
      participant_a.connect_from(participant_b)
      participant_a.connected_to_ids.should include(participant_b.id)
      participant_a.connected_to_ids.length.should == 1
    end
  end

  describe '#generate_pin' do
    let(:participant) {Participant.new}
    it 'generates pin of 4 digits' do
      participant.generate_pin.length.should ==4
    end

    it 'generates unique pins' do
      pins = []
      15.times do |counter|
        Participant.stub(:count).and_return(counter)
        pins << participant.generate_pin
      end
      pins.uniq.length.should == pins.length
    end
  end

  describe '#rank' do
    it 'returns participant in order based on their score' do
      participant_a = Participant.create!(phone_number: "0400000", username: 'A', connected_to_ids: [0,1])
      participant_b = Participant.create!(phone_number: "0400001", username: 'B', connected_to_ids: [0,1,3,4])
      participant_c = Participant.create!(phone_number: "0400002", username: 'C', connected_to_ids: [0,1,4])

      Participant.rank.should == [participant_b, participant_c, participant_a]
    end
  end

end