require_relative '../models/participant'

module Email
  def create(data)
    participant = EmailParticipant.create!(:email => data["email"])
    send_email(participant, "Thank you for registering!")
  end

  def vote(from_email, to_email)
  end

  private

  def send_email(participant, body)
  end
end