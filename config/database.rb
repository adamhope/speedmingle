require 'mongo_mapper'
require 'uri'
require 'mongo_mapper'

if ENV['MONGOLAB_URI']
  MongoMapper.connection = Mongo::Connection.from_uri ENV['MONGOLAB_URI']
  MongoMapper.database = URI.parse(ENV['MONGOLAB_URI']).path.gsub(/^\//, '')
else
  MongoMapper.connection = Mongo::Connection.from_uri settings.db_uri
  MongoMapper.database = URI.parse(settings.db_uri).path.gsub(/^\//, '')
end