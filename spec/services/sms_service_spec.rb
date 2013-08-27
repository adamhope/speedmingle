require 'spec_helper'

describe 'SmsService' do
  
  let(:sms_service) {SmsService.new}

  describe '#register' do
    context 'participant is new' do
      it 'creates a new participant' do
        sms_service.register('0410101010', 'Fred')
        Participant.count.should == 1
        Participant.first.username.should == 'Fred'
        Participant.first.phone_number.should == '0410101010'
      end

      it 'sends a welcome message' do
        sms_service.should_receive(:send_sms).with('0410101010', /Fred, thank you for registering. Your PIN is \d000/)
        sms_service.register('0410101010', 'Fred')
      end

    end

    context 'participant is already registered' do
      let!(:participant) {Participant.create!(phone_number: '04111111', username: 'Fred')}
      it 'sends a message explaining that the participant is already registered' do
        sms_service.should_receive(:send_sms).with(participant.phone_number, "Fred, you are already registered and your PIN is #{participant.pin}")
        sms_service.register(participant.phone_number, participant.username)
      end
    end

    context 'participant username is already taken' do
      let!(:participant) {Participant.create!(phone_number: '04111111', username: 'Fred')}

      it 'sends a message explaining that the username has already been taken' do
        sms_service.should_receive(:send_sms).with('11111111', "Sorry, #{participant.username} is already taken. Please try a different username.")
        sms_service.register('11111111', participant.username)
      end
    end

  end

  describe '#connect' do 
    before do
      @participant_a = Participant.create!(phone_number: '0411111111', username: 'Fred')
      @participant_b = Participant.create!(phone_number: '0422222222', username: 'Dom')
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
        sms_service.should_receive(:send_sms).with(@participant_a.phone_number, 'Thanks for connecting with Dom')
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