require 'spec_helper'

describe 'The SMS voting game version 2' do

  it "says hello" do
    get '/'
    last_response.body.should =~ /Hello World/
  end

  context "participants" do
    it "returns a list of participants" do
      get '/participants'
      last_response.body.should == { name: 'Dominic', age: 23 }.to_json
    end

    it "returns a single participant by id" do
      get '/participants/1'
      last_response.body.should == { name: 'Dominic', age: 23 }.to_json
    end

    it "creates a participant" do
      p = { name: 'Dominic', age: 23 }.to_json
      post '/participants/create', p, {'Content-Type' => 'application/json'}
      last_response.should be_ok
    end

    it "deletes a participant" do
      put '/participants/delete', p, {'Content-Type' => 'application/json'}
    end
  end
end