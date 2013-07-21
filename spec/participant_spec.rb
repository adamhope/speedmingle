require 'spec_helper'

describe 'The participant model' do

  it "should create a new participant, and be returned by id" do
    participant = EmailParticipant.create!(:email => "dom@dom.com")
    EmailParticipant.where(:id => participant.id).first.email.should == "dom@dom.com"
  end

  it "should return a list of participants" do
    EmailParticipant.create!(:email => "dom@dom.com")
    EmailParticipant.create!(:email => "dom1@dom1.com")
    EmailParticipant.count.should == 2
  end

  it "should delete an existing participant" do
    participant = EmailParticipant.create!(:email => "dom@dom.com")
    EmailParticipant.all.length.should == 1
    participant.destroy
    EmailParticipant.count.should == 0
  end

end