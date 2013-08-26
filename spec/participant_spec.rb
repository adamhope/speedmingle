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

  describe '#generate_pin' do
    let(:participant) {Participant.new}
    it 'generates pin of 4 digits' do
      participant.generate_pin.length.should ==4
    end

    it 'generates unique pins' do
      pins = []
      20.times do |counter|
        Participant.stub(:count).and_return(counter)
        pins << participant.generate_pin
      end
      pins.uniq.length.should == pins.length
    end
  end

end