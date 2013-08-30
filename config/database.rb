require 'mongo_mapper'
require 'uri'
require 'mongo_mapper'

# # Configure the environment
if ENV['MONGOLAB_URI']
  mongo_url = ENV['MONGOLAB_URI']
  MongoMapper.connection = Mongo::Connection.from_uri mongo_url
  MongoMapper.database = URI.parse(mongo_url).path.gsub(/^\//, '') #Extracts 'dbname' from the uri
else
  db_host = "localhost"
  db_port = "27017"
  db_name = test? ? "speedmingle-test" : "speedmingle-dev"
  MongoMapper.connection = Mongo::Connection.new(db_host, db_port)
  MongoMapper.database = db_name
  MongoMapper.connection.connect
end