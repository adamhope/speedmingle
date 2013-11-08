class ParticipantService

  require 'faker'

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

  def connect_random
    participant_from = Participant.first(:offset => rand(Participant.count))
    participant_to = Participant.first(:offset => rand(Participant.count))
    participant_to.connect_from(participant_from)
  end

  def register_random(count)
    created = []
    count.to_i.times do
      phone_number = Faker::PhoneNumber.phone_number
      username = Faker::Name.name
      created << register(phone_number, username)
    end
    created
  end
end