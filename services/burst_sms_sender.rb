require 'net/http'

class BurstSmsSender
  def initialize(args)
    @api_url = args[:api_url].dup
    @api_key = args[:api_key].dup
    @api_secret = args[:api_secret].dup
    @caller_id = args[:caller_id].dup
  end

  def send_sms(phone_number, message)
    uri = URI.parse("#{@api_url}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.request_uri)
    req.basic_auth(@api_key, @api_secret)
    req.set_form_data({'message' => message, 'to' => phone_number})
    http.request(req)
  end

  def uri(phone_number, message)
    # message_with_plus = message.split(' ').join('+')
    # url = @api_url.clone
    # url << "messages.single"
    # url << "?apikey=#{@api_key}"
    # url << "&apisecret=#{@api_secret}"
    # url << "&mobile=#{phone_number}"
    # url << "&message=#{message_with_plus}"
    # url << "&caller_id=#{@caller_id}"
    # url
    "#{@api_url}send-sms.json -u #{@api_key}:#{@api_secret} -d 'message=#{message}' -d to=#{phone_number}"
  end
end
