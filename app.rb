require 'sinatra'
require './config/init'
require 'sinatra/partial'
require 'pry-debugger'

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

# Return a specific participant, using it's ID
get '/participants/:id' do |id|
  content_type :json
  Participant.where(id: id).first.to_json
end

delete '/participants/:id' do |id|
  Participant.where(id: id).first.destroy
end

post '/participants/create', :provides => :json do
  data = JSON.parse request.body.read
  p = service.create(data)
  if p.errors.empty?
    p.to_json
  else
    error 400, p.errors.to_json
  end
end

post 'participants/vote' do
  data = JSON.parse request.body.read
  service.vote(data)
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

end
