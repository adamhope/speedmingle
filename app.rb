require 'sinatra'
require 'json'
require 'slim'
require 'require_all'
require 'pry-debugger'
require_all 'config/init'
require_all 'messaging'
require_all 'models'

handler = MessageHandler.create(Email)

set :slim, :pretty => true

get '/' do
   "Hello World! Is it me you're looking for?"
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