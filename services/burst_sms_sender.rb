require 'net/http'

class BurstSmsSender
  def initialize(args)
    @api_url = args[:api_url].dup
    @api_key = args[:api_key].dup
    @api_secret = args[:api_secret].dup
    @caller_id = args[:caller_id].dup
  end

  def send_sms(phone_number, message)
    Net::HTTP.get_response(URI.parse(uri(phone_number, message)))
  end

  def uri(phone_number, message)
    message_with_plus = message.split(' ').join('+')
    url = @api_url.clone
    url << "messages.single"
    url << "?apikey=#{@api_key}"
    url << "&apisecret=#{@api_secret}"
    url << "&mobile=#{phone_number}"
    url << "&message=#{message_with_plus}"
    url << "&caller_id=#{@caller_id}"
    url
  end
end