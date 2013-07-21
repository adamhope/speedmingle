require_relative '../models/participant'

module Email
  def create(data)
    participant = Participant.create!(:email => data["email"])
  end
end