require 'sinatra'
require './config/init'
require 'sinatra/partial'

handler = MessageHandler.create(Email)   

get '/' do
   slim :'index'
end

get '/participants/list' do
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

post '/participants/create' do
  data = JSON.parse request.body.read
  handler.create(data)
end

post 'participants/vote' do
  data = JSON.parse request.body.read
  handler.vote(data)
end

get '/leaderboard' do

end