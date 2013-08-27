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

      it 'sends thank you message' do
        sms_service.should_receive(:send_sms).with(@participant_a.phone_number, 'Thanks for connecting with')
        sms_service.connect @participant_a.phone_number, @participant_b.pin 
      end
    end

    context 'no participant has the pin' do
      it 'sends a message informing the participant that the pin is incorrect' do
        sms_service.should_receive(:send_sms).with(@participant_a.phone_number, 'Invalid pin')
        sms_service.connect @participant_a.phone_number, '00000'
      end
    end

    context 'the participant is not registered' do
      it 'sends a message informing the participant that he must register before connecting' do
        sms_service.should_receive(:send_sms).with('00000000', 'Sorry, you must register before connecting. SMS your full name to register')
        sms_service.connect '00000000', @participant_b.pin
      end
    end
  end
end