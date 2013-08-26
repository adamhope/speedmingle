class SmsService
  def create(data)
    p = Participant.new(phone_number: data["phone_number"])
    if p.save
      send_sms(p, "Thank you for registering #{p.phone_number}.")
    end
    p
  end

  def vote(phone_number_from, pin_to)
  end

  private

  def send_sms(participant, message)
    puts message
  end
end