require 'sinatra'
require './config/init'
require 'sinatra/partial'

service = SmsService.new

get '/' do
   slim :'index'
end

get '/admin/participants' do
  @participants = Participant.all
  slim :'participants/index'
end

# Returns all participants in database
get '/participants' do
  content_type :json
  Participant.all.to_json
end

# Return a specific participant, using it's PIN
get '/participants/:pin' do |pin|
  content_type :json
  Participant.where(pin: pin).first.to_json
end

delete '/participants/:pin' do |pin|
  Participant.where(pin: pin).first.destroy
end

post '/participants/register', :provides => :json do
  data = JSON.parse request.body.read
  p = service.register(data["phone_number"], data["username"])
  if p.errors.empty?
    p.to_json
  else
    error 400, p.errors.to_json
  end
end

post '/participants/connect', :provides => :json do
  data = JSON.parse request.body.read
  service.connect(data["from_phone_number"], data["to_pin"])
end

get '/fx/leaderboard' do
  slim :'fx/leaderboard'
end

get '/fx/scoreboard' do
  slim :'fx/scoreboard'
end

get '/fx/swarm' do
  slim :'fx/swarm'
end

get '/fx/connections' do
  slim :'fx/connections'
end

get '/sample_data/participants' do
  content_type :json
  send_file File.join(settings.public_folder, 'js/sample_data/participants.json')
end

get '/sample_data/links' do
  content_type :json
  send_file File.join(settings.public_folder, 'js/sample_data/links.json')
end
