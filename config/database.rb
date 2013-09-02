require 'mongo_mapper'
require 'uri'
require 'mongo_mapper'

# Configure the environment
if ENV['MONGOLAB_URI']
  mongo_url = ENV['MONGOLAB_URI']
  MongoMapper.connection = Mongo::Connection.from_uri mongo_url
else
  MongoMapper.connection = Mongo::Connection.new(settings.db_host, settings.db_port)
  MongoMapper.database = settings.db_name
  MongoMapper.connection.connect
end