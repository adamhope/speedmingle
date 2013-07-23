require 'json'
require 'slim'
require 'sass/plugin/rack'
require 'require_all'
require_all 'config/database'
require_all 'messaging'
require_all 'models'

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack