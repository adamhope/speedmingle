class SmsService
  def initialize(sender, participant_service)
    @sender = sender
    @participant_service = participant_service
  end

  def register(phone_number, username)
    message = nil
    begin
      participant = @participant_service.register(phone_number, username)
      message = "#{participant.username}, thank you for registering. Your PIN is #{participant.pin}"
    
    rescue SpeedmingleErrors::AlreadyRegistered => e
      message = "#{e.args[:participant].username}, you are already registered and your PIN is #{e.args[:participant].pin}"
    
    rescue SpeedmingleErrors::UsernameTaken
      message = "Sorry, #{username} is already taken. Please try a different username."
    
    ensure
      @sender.send_sms(phone_number, message) if message
    end
  end

  def connect(phone_number_from, pin_to)
    message = nil
    begin
      participant_to = @participant_service.connect(phone_number_from, pin_to)
      message = "Thanks for connecting with #{participant_to.username}"
    
    rescue SpeedmingleErrors::InvalidPin
      message = 'Invalid pin'

    rescue SpeedmingleErrors::RegistrationNeeded
      message = 'Sorry, you must register before connecting. SMS your full name to register'

    ensure
      @sender.send_sms(phone_number_from, message)
    end
  end

  def broadcast_ranking
    participants = Participant.rank
    top_score = participants.first.score
    leaders = participants.select {|p| p.score == top_score}
    if leaders.count == 1
      send_in_the_lead(participants.shift)
    end
    participants.each do |p|
      send_connections_away_from_the_lead(top_score, p)
    end
  end

  private

  def send_in_the_lead(participant)
    @sender.send_sms(participant.phone_number, "#{participant.username}, you are in the lead.")
  end

  def send_connections_away_from_the_lead(top_score, participant)
    diff_score = top_score - participant.score + 1
    n_connections = diff_score > 1 ? "#{diff_score} connections" : "#{diff_score} connection"
    @sender.send_sms(participant.phone_number, "#{participant.username}, you are #{n_connections} away from the lead.")
  end
end