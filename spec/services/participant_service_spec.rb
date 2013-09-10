require 'spec_helper'

describe 'ParticipantService' do
  
  let(:participant_service) {ParticipantService.new}

  describe '#register' do
    context 'participant is new' do
      it 'creates a new participant' do
        participant_service.register('0410101010', 'Fred')
        Participant.count.should == 1
        Participant.first.username.should == 'Fred'
        Participant.first.phone_number.should == '0410101010'
      end

      it 'returns the newly created participant' do
        p = participant_service.register('0410101010', 'Fred')
        Participant.first.id.should == p.id
        p.username.should == 'Fred'
        p.phone_number.should == '0410101010'
      end
    end

    context 'participant is already registered' do
      let!(:participant) {Participant.create!(phone_number: '04111111', username: 'Fred')}
      
      it 'raises already registered error' do
        expect {participant_service.register(participant.phone_number, participant.username)}.to raise_error(SpeedmingleErrors::AlreadyRegistered)
      end
    end

    context 'participant username is already taken' do
      let!(:participant) {Participant.create!(phone_number: '04111111', username: 'Fred')}

      it 'raises username taken error' do
        expect {participant_service.register('11111111', participant.username)}.to raise_error(SpeedmingleErrors::UsernameTaken)
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
        participant_service.connect @participant_a.phone_number, @participant_b.pin 
        @participant_b.reload
        @participant_b.score.should == 1
        @participant_b.connected_to_ids.should == [@participant_a.id]
        @participant_a.reload
        @participant_a.score.should == 0
      end
    end

    context 'no participant has the pin' do
      it 'raises invalid pin error' do
        expect {participant_service.connect @participant_a.phone_number, '00000'}.to raise_error(SpeedmingleErrors::InvalidPin)
      end
    end

    context 'the participant is not registered' do
      it 'raises registration needed error' do
        expect {participant_service.connect '00000000', @participant_b.pin}.to raise_error(SpeedmingleErrors::RegistrationNeeded)
      end
    end
  end
end