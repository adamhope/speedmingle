require 'spec_helper'

describe 'SmsService' do
  
  let(:sms_service) do 
    service = SmsService.new
    service.stub(:send_sms)
    service
  end

  describe '#connect' do 
    before do
      @participant_a = Participant.create!(phone_number: '0411111111')
      @participant_b = Participant.create!(phone_number: '0422222222')
    end

    context 'both participant exist' do
      it 'connects one participant to another' do 
        @participant_b.score.should == 0
        sms_service.connect @participant_a.phone_number, @participant_b.pin 
        @participant_b.reload
        @participant_b.score.should == 1
        @participant_b.connected_to_ids.should == [@participant_a.id]
        @participant_a.reload
        @participant_a.score.should == 0
      end
    end
  end
end