require 'spec_helper'

describe 'BurstSmsSender' do
  
  let(:burst_sms) {BurstSmsSender.new(api_url: 'http://www.some-url.com/sms/', api_key: 'somekey', api_secret: 'somesecret', caller_id: '041111111111')}
  
  describe 'uri' do
    it 'returns the Burst sms url' do
      url = burst_sms.uri('0414213852', 'Hello world')
      url.should == 'http://www.some-url.com/sms/messages.single?apikey=somekey&apisecret=somesecret&mobile=0414213852&message=Hello+world&caller_id=041111111111'
    end
  end

end