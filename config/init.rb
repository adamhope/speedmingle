require "sinatra/reloader" if development?
require 'json'
require 'slim'
require 'sass/plugin/rack'
require "sinatra/config_file"
require 'require_all'

configure :development do
  set :db_uri, 'mongodb://localhost/speedmingle-dev'
  set :auth_username, ''
  set :auth_password, ''
  set :burst_api_url, ENV['BURST_API_URL'] || "foo"
  set :burst_api_key, ENV['BURST_API_KEY']
  set :burst_api_secret, ENV['BURST_API_SECRET']
  set :burst_caller_id, ENV['BURST_CALLER_ID']
end

configure :test do
  set :db_uri, 'mongodb://localhost/speedmingle-test'
  set :auth_username, ''
  set :auth_password, ''
end

configure :production do
  set :db_uri, ENV['MONGOLAB_URI']
  set :auth_username, ENV['SETTINGS_AUTH_USERNAME'] || 'needtobechanged'
  set :auth_password, ENV['SETTINGS_AUTH_PASSWORD'] || 'needtobechanged'
  set :burst_api_url, ENV['BURST_API_URL']
  set :burst_api_key, ENV['BURST_API_KEY']
  set :burst_api_secret, ENV['BURST_API_SECRET']
  set :burst_caller_id, ENV['BURST_CALLER_ID']
end

require_all 'config/database'
require_all 'services'
require_all 'models'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack