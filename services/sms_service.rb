class SmsService
  def create(data)
    p = Participant.new(phone_number: data["phone_number"])
    if p.save
      send_sms(p, "Thank you for registering #{p.phone_number}.")
    end
    p
  end

  def connect(phone_number_from, pin_to)
    participant_from = Participant.find_by_phone_number(phone_number_from)
    if participant_from
      participant_to = Participant.find_by_pin(pin_to)
      if participant_to
        # participant_to.
      end
    end
  end

  private

  def send_sms(participant, message)
    puts message
  end

end