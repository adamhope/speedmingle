require 'pry'

class MessageHandler
  def self.create provider
    o = new
    o.extend(provider)
  end
end