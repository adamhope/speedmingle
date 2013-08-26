require 'spec_helper'

describe 'SmsService' do
  
  let!(:sms_service) {SmsService.new}

  describe '#vote' do 
    before do
      @participant_a = Participant.create(phone_number: )
    end

    it 'adds the phone number of the registered participant' do 
      sms_service.vote '0401010101', '1234'
      Participant.count.should == 1
    end
  end
end