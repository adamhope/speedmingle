class SmsService

  def create(data)
    Participant.create(phone_number: data["phone_number"])
  end

  def vote(from_id, to_id)
  end
end