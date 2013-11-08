require 'sinatra'
require './config/init'
require 'sinatra/partial'

helpers do
  def protected!
    return if authorized?
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == [settings.auth_username, settings.auth_password]
  end
end

participant_service = ParticipantService.new
if settings.production?
  burst_sender = BurstSmsSender.new(
    api_url:settings.burst_api_url,
    api_key: settings.burst_api_key,
    api_secret: settings.burst_api_secret,
    caller_id: settings.burst_caller_id)
  sms_service = SmsService.new(burst_sender, participant_service)
else
  sms_service = SmsService.new(BasicSender.new, participant_service)
end

get '/' do
   slim :'index'
end

get '/admin/participants' do
  protected!
  @participants = Participant.all
  slim :'participants/index'
end

# Returns all participants in database
get '/participants' do
  content_type :json
  Participant.rank.to_json
end

get '/participants/links' do
  content_type :json
  Participant.links.to_json
end

get '/participants/bubbles' do
  content_type :json
  Participant.bubbles.to_json
end

post '/participants/random' do
  protected!
  content_type :json
  data = JSON.parse request.body.read
  ps = participant_service.register_random(data["count"])
  if !ps.empty?
    ps.to_json
  else
    error 400
  end
end

get '/participants/connect_random' do
  protected!
  content_type :json
  p = participant_service.connect_random
  if p.errors.empty?
    p.to_json
  else
    error 400, p.errors.to_json
  end
end

# Return a specific participant, using it's PIN
get '/participants/:pin' do |pin|
  protected!
  content_type :json
  Participant.where(pin: pin).first.to_json
end

delete '/participants/:pin' do |pin|
  protected!
  Participant.where(pin: pin).first.destroy
end

post '/participants/register', :provides => :json do
  protected!
  data = JSON.parse request.body.read
  p = participant_service.register(data["phone_number"], data["username"])
  if p.errors.empty?
    p.to_json
  else
    error 400, p.errors.to_json
  end
end

post '/participants/connect', :provides => :json do
  protected!
  data = JSON.parse request.body.read
  participant_service.connect(data["from"], data["to"])
end

# /sms/dispatch/?mobile=1234567890&response=Fred&message_id=0
get '/sms/dispatch/' do
  if /^\d+$/.match params['response']
    sms_service.connect(params["mobile"], params["response"])
  else
    sms_service.register(params["mobile"], params["response"])
  end
end

get '/dashboard' do
  slim :"dashboard"
end

get '/fx/:viz' do |v|
  slim :"fx/#{v}"
end

get '/info/:words' do |w|
  slim :"info/#{w}"
end

get '/sample_data/participants' do
  content_type :json
  send_file File.join(settings.public_folder, 'js/sample_data/participants.json')
end
