require 'json'
require 'slim'
require 'sass/plugin/rack'
require "sinatra/config_file"
require 'require_all'

config_file 'config/config.yml'

require_all 'config/database'
require_all 'services'
require_all 'models'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack