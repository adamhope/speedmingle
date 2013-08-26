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

end