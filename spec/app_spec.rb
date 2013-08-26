require 'spec_helper'

describe 'The SMS voting game version 2' do
  context "participants" do

    before :each do
      @p1 = Participant.create!(phone_number: "0414213852")
      @p2 = Participant.create!(phone_number: "0404882585")
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
      p = { phone_number: "000000000" }.to_json
      post '/participants/create', p, {'Content-Type' => 'application/json'}
      Participant.where(phone_number: "000000000").first.present?.should == true
    end

    it "deletes a participant" do
      Participant.count.should == 2
      delete "/participants/#{@p2.id}"
      Participant.count.should == 1
      Participant.where(phone_number: @p2.phone_number).first.should be_nil
    end 
  end
end