require 'net/http'

class BurstSmsSender
  def initialize(args)
    @api_url = args[:api_url]
    @api_key = args[:api_key]
    @api_secret = args[:api_secret]
    @caller_id = args[:caller_id]
  end

  def send_sms(phone_number, message)
    Net::HTTP.get(uri(phone_number, message))
  end

  def uri(phone_number, message)
    message_with_plus = message.split(' ').join('+')
    url = @api_url
    url << "messages.single"
    url << "?apikey=#{@api_key}"
    url << "&apisecret=#{@api_secret}"
    url << "&mobile=#{phone_number}"
    url << "&message=#{message_with_plus}"
    url << "&caller_id=#{@caller_id}"
    url
  end
end