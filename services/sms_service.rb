class SmsService
  def create(data)
    p = Participant.new(phone_number: data["phone_number"], username: data["username"])
    if p.save
      send_sms(p, "Thank you for registering #{p.phone_number}.")
    end
    p
  end

  def register(phone_number, username)
    message = nil
    if participant = Participant.find_by_phone_number(phone_number)
      message = "#{participant.username}, you are already registered and your PIN is #{participant.pin}"
    else
      participant = Participant.new(phone_number: phone_number, username: username)
      if participant.save
        message = "#{username}, thank you for registering. Your PIN is #{participant.pin}"
      else
        message = "Sorry, #{username} is already taken. Please try a different username."
      end
    end
    send_sms(phone_number, message) if message
  end

  def connect(phone_number_from, pin_to)
    participant_from = Participant.find_by_phone_number(phone_number_from)
    message = if participant_from
      participant_to = Participant.find_by_pin(pin_to)
      if participant_to
        participant_to.connect_from(participant_from)
        "Thanks for connecting with #{participant_to.username}"
      else
        'Invalid pin'
      end
    else
      'Sorry, you must register before connecting. SMS your full name to register'
    end
    send_sms(phone_number_from, message)
  end

  private

  def send_sms(phone_number, message)
    puts message
  end

end