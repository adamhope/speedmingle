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
end