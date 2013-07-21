require 'spec_helper'

describe 'The participant model' do

  it "should create a new participant" do
    participant = EmailParticipant.create!(:email => "dom@dom.com")
    participant.email.should == "dom@dom.com"
  end

  it "should return a list of participants" do
    EmailParticipant.create!(:email => "dom@dom.com")
    EmailParticipant.create!(:email => "dom1@dom1.com")
    EmailParticipant.all.length.should == 2
  end

  it "should return a specific participant via id" do 
  end

  it "should delete an existing participant" do
  end

end