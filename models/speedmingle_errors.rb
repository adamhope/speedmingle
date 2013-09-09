class SpeedmingleErrors
  class Error < StandardError
    attr_reader :args
    def initialize(args = {})
      @args = args
    end
  end

  class AlreadyRegistered < Error
  end

  class UsernameTaken < Error
  end

  class InvalidPin < Error
  end

  class RegistrationNeeded < Error
  end
end