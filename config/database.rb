require 'mongo_mapper'
require 'uri'
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.from_uri settings.db_uri
MongoMapper.database = settings.db_name
