module Sms

  def create(data)
    # participant = Participant.create!(:phone_number => data["phone_number"])
    # send the phone_number who created this participant, 
    # an ID back, and a welcome message
  end

  def vote(from_id, to_id)
    'Voted for #{from_id} #{to_id}'
  end
end