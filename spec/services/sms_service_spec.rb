require 'spec_helper'

describe 'SmsService' do
  
  let(:sender) { BasicSender.new }
  let(:participant_service) { ParticipantService.new }
  let(:sms_service) { SmsService.new(sender, participant_service) }

  describe '#register' do
    context 'participant is new' do
      it 'sends a welcome message' do
        sender.should_receive(:send_sms).with('0410101010', /Fred, thank you for registering. Your PIN is \d000/)
        sms_service.register('0410101010', 'Fred')
      end
    end

    context 'when already registered error' do
      let!(:participant) {Participant.create!(phone_number: '04111111', username: 'Fred')}
      it 'sends a message explaining that the participant is already registered' do
        sender.should_receive(:send_sms).with(participant.phone_number, "Fred, you are already registered and your PIN is #{participant.pin}")
        sms_service.register(participant.phone_number, participant.username)
      end
    end

    context 'when username taken error' do
      let!(:participant) {Participant.create!(phone_number: '04111111', username: 'Fred')}

      it 'sends a message explaining that the username has already been taken' do
        sender.should_receive(:send_sms).with('11111111', "Sorry, #{participant.username} is already taken. Please try a different username.")
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
      it 'sends thank you message' do
        sender.should_receive(:send_sms).with(@participant_a.phone_number, 'Thanks for connecting with Dom')
        sms_service.connect @participant_a.phone_number, @participant_b.pin 
      end
    end

    context 'when invalid pin error' do
      it 'sends a message informing the participant that the pin is incorrect' do
        sender.should_receive(:send_sms).with(@participant_a.phone_number, 'Invalid pin')
        sms_service.connect @participant_a.phone_number, '00000'
      end
    end

    context 'when registration needed error' do
      it 'sends a message informing the participant that he must register before connecting' do
        sender.should_receive(:send_sms).with('00000000', 'Sorry, you must register before connecting. SMS your full name to register')
        sms_service.connect '00000000', @participant_b.pin
      end
    end
  end

  describe '#broadcast_hints' do
    before do
      @participant = Participant.create!(phone_number: "0400000", username: 'A', connected_to_ids: [])
    end

    context '1 participant' do
      it 'doesnt send you a hint message' do
        sender.should_not_receive(:send_sms)
        sms_service.broadcast_hints
      end
    end

    context '2 participants' do
      before do
        @participant2 = Participant.create!(phone_number: "0400001", username: 'B', connected_to_ids: [])
      end

      it 'sends a hint message suggesting to find participant2' do
        sender.should_receive(:send_sms).with(@participant.phone_number, "You haven't connected with #{@participant2.username}. Try and find them!")
        sender.should_receive(:send_sms).with(@participant2.phone_number, "You haven't connected with #{@participant.username}. Try and find them!")
        sms_service.broadcast_hints
      end
    end
  end

  describe '#broadcast_ranking' do
    context '1 participant' do
      before do
        @participant = Participant.create!(phone_number: "0400000", username: 'A', connected_to_ids: [0,1])
      end
      it 'sends you are in the lead sms' do
        sender.should_receive(:send_sms).with(@participant.phone_number, "#{@participant.username}, you are in the lead.")
        sms_service.broadcast_ranking
      end
    end

    context 'more than one participant' do
      context 'when no equality for the first place' do
        before do
          @participant_a = Participant.create!(phone_number: "0400000", username: 'A', connected_to_ids: [0,1])
          @leader = Participant.create!(phone_number: "0400001", username: 'B', connected_to_ids: [0,1,3,4])
          @participant_b = Participant.create!(phone_number: "0400002", username: 'C', connected_to_ids: [0,1,4])
        end

        it 'sends sms to all participants based on their score' do
          sender.should_receive(:send_sms).with(@leader.phone_number, "#{@leader.username}, you are in the lead.")
          sender.should_receive(:send_sms).with(@participant_b.phone_number, "#{@participant_b.username}, you are 2 connections away from the lead.")
          sender.should_receive(:send_sms).with(@participant_a.phone_number, "#{@participant_a.username}, you are 3 connections away from the lead.")

          sms_service.broadcast_ranking
        end
      end

      context 'with equality for the first place' do
        before do 
          @leader_a = Participant.create!(phone_number: "0400000", username: 'A', connected_to_ids: [0,1,3,4])
          @leader_b = Participant.create!(phone_number: "0400001", username: 'B', connected_to_ids: [0,1,3,4])
          @participant = Participant.create!(phone_number: "0400002", username: 'C', connected_to_ids: [0,1,4])
        end

        it 'send sms to all participants based on their score' do
          sender.should_receive(:send_sms).with(@leader_a.phone_number, "#{@leader_a.username}, you are 1 connection away from the lead.")
          sender.should_receive(:send_sms).with(@leader_b.phone_number, "#{@leader_b.username}, you are 1 connection away from the lead.")
          sender.should_receive(:send_sms).with(@participant.phone_number, "#{@participant.username}, you are 2 connections away from the lead.")

          sms_service.broadcast_ranking
        end
      end
    end
  end
end