require 'spec_helper'

describe 'The SMS voting game version 2' do

  it "says hello" do
    get '/'
    last_response.body.should =~ /Hello World/
  end

  context "participants" do

    before :each do
      @p1 = EmailParticipant.create!(:email => "dom@dom.com")
      @p2 = EmailParticipant.create!(:email => "dom2@dom.com")
    end

    it "returns a list of participants" do
      get '/participants'
      last_response.body.should == [@p1, @p2].to_json
    end

    it "returns a single participant by id" do
      get "/participants/#{@p1.id}"
      last_response.body.should == @p1.to_json
    end

    it "creates a participant" do
      p = { email: "dom3@dom.com" }.to_json
      post '/participants/create', p, {'Content-Type' => 'application/json'}
      Participant.where(email: "dom3@dom.com").first.present?.should == true
    end

    it "deletes a participant" do
      Participant.count.should == 2
      delete "/participants/#{@p2.id}"
      Participant.count.should == 1
      Participant.where(email: @p2.email).first.should be_nil
    end 
  end
end