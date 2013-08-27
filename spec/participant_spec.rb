require 'spec_helper'

describe 'The participant model' do
  
  it "should create a new participant, and be returned by id" do
    participant = Participant.create!(phone_number: "0414213852")
    Participant.where(:id => participant.id).first.phone_number.should == "0414213852"
  end

  it "should return a list of participants" do
    Participant.create!(phone_number: "0414213852")
    Participant.create!(phone_number: "0404882585")
    Participant.count.should == 2
  end

  it "should delete an existing participant" do
    participant = Participant.create!(phone_number: "0414213852")
    Participant.all.length.should == 1
    participant.destroy
    Participant.count.should == 0
  end

  it 'sets a unique pin when creating' do
    participant = Participant.new(phone_number: '02020202')
    participant.pin.should be_nil
    participant.save
    participant.pin.should_not be_nil
  end

  describe '#connect_to' do
    let!(:participant_a) {Participant.create!(phone_number: '0411221122')}
    let!(:participant_b) {Participant.create!(phone_number: '0400000000')}

    it 'adds the participant if not already there' do
      participant_a.connect_to(participant_b)
      participant_a.connected_to_ids.should include(participant_b.id)
      participant_a.connected_to_ids.length.should == 1
    end

    it 'does not add participant if already there' do
      participant_a.connect_to(participant_b)
      participant_a.connect_to(participant_b)
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

end