require 'sinatra'
require 'json'
require 'sinatra/json'
require 'require_all'
require_all 'config/init'
require_all 'messaging'

get '/' do
   "Hello World! Is it me you're looking for?"
end

get '/participants' do
  content_type :json
  { name: 'Dominic', age: 23 }.to_json
end

get '/participants/:id' do
  content_type :json
  { name: 'Dominic', age: 23 }.to_json
end

post '/participants/create' do
  data = JSON.parse request.body.read
  participant_id = handler.create(data)
end

post 'participants/vote' do
  data = JSON.parse request.body.read
end