require "sinatra/reloader" if development?
require 'json'
require 'slim'
require 'sass/plugin/rack'
require "sinatra/config_file"
require 'require_all'

configure :development do
  set :db_uri, 'mongodb://localhost/speedmingle-dev'
  set :auth_username, 'admin'
  set :auth_password, 'p@ssW0rd'
  set :burst_api_url, 'https://api.transmitsms.com/send-sms.json'
  set :burst_api_key, 'c69852c03eecbcf02e9387aae618091d'
  set :burst_api_secret, 'twopenhouse'
  set :burst_caller_id, '+61419741136'
end

configure :test do
  set :db_uri, 'mongodb://localhost/speedmingle-test'
  set :auth_username, ''
  set :auth_password, ''
end

configure :production do
  set :db_uri, "mongodb://heroku:oQ8-04IDlmSQARfBpWsjbfEO30zEPcoA3ta4Czi7_PFLHewtI39ua-dK7SNzfrdZM38HbHb7jKbYlBhJtHwqCQ@kahana.mongohq.com:10073/app26455644"
  set :auth_username, 'admin'
  set :auth_password, 'p@ssW0rd'
  set :burst_api_url, 'https://api.transmitsms.com/send-sms.json'
  set :burst_api_key, 'c69852c03eecbcf02e9387aae618091d'
  set :burst_api_secret, 'twopenhouse'
  set :burst_caller_id, '+61419741136'
end

require_all 'config/database'
require_all 'services'
require_all 'models'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack
