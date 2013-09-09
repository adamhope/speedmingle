class ParticipantService

  def register(phone_number, username)
    if participant = Participant.find_by_phone_number(phone_number)
      raise SpeedmingleErrors::AlreadyRegistered.new(participant: participant)
    else
      participant = Participant.new(phone_number: phone_number, username: username)
      if participant.save
        participant  
      else
        raise SpeedmingleErrors::UsernameTaken.new(username: username)
      end
    end
  end

  def connect(phone_number_from, pin_to)
    participant_from = Participant.find_by_phone_number(phone_number_from)
    if participant_from
      participant_to = Participant.find_by_pin(pin_to)
      if participant_to
        participant_to.connect_from(participant_from)
        participant_to
      else
        raise SpeedmingleErrors::InvalidPin.new(pin: pin_to)
      end
    else
      raise SpeedmingleErrors::RegistrationNeeded.new
    end
  end
end