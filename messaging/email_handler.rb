require_relative '../models/participant'

module Email
  def create(data)
    participant = Participant.create!(:email => data["email"])
    email_participant(participant, "Thank you for registering!")
  end

  def vote(from_email, to_email)
  end

  private

  def email_participant(participant, body)

  end
end