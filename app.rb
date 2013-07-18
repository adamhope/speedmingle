require "bundler/setup"
require 'sinatra'

get '/' do
   "Hello World! Is it me you're looking for?"
end

get '/participants' do
  "Participants"  
end

get '/participants/links' do
  "Participants links"  
end
