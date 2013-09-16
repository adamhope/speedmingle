require 'spec_helper'

describe 'The SMS voting game version 2' do
  context "participants" do

    before :each do
      @p1 = Participant.create!(phone_number: "0414213852", username: 'Fred', connected_to_ids: [1,2])
      @p2 = Participant.create!(phone_number: "0404882585", username: 'Dom', connected_to_ids: [])
    end

    it "returns a list of participants" do
      get '/participants'
      last_response.body.should == [@p1, @p2].to_json
    end

    it "returns a single participant by pin" do
      get "/participants/#{@p1.pin}"
      last_response.body.should == @p1.to_json
    end

    it "creates a participant" do
      p = { phone_number: "000000000", username: "Dominic" }.to_json
      post '/participants/register', p, {'Content-Type' => 'application/json'}
      Participant.where(phone_number: "000000000").first.present?.should == true
    end

    it "deletes a participant by pin" do
      Participant.count.should == 2
      delete "/participants/#{@p2.pin}"
      Participant.count.should == 1
      Participant.where(phone_number: @p2.phone_number).first.should be_nil
    end

    it "connects two participants" do
      p = { from_phone_number: @p1.phone_number, to_pin: @p2.pin }.to_json
      post '/participants/connect', p, {'Content-Type' => 'application/json'}
      @p2.reload.connected_to_ids.should include(@p1.id)
    end
  end
end