require 'sinatra'
require_relative '../models/participant'

module Email
  def create(data)
    ep = EmailParticipant.new(:email => data["email"])
    if ep.save
      send_email(p, "Thank you for registering!")
    end
    ep
  end

  def vote(from_email, to_email)
  end

  private

  def send_email(participant, body)
  end
end