class SmsService

  def create(data)
    SmsParticipant.create(phone_number: data["phone_number"])
  end

  def vote(from_id, to_id)
  end
end