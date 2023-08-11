class InvalidUserInputError < StandardError
  def initialize(message)
    super(message)
  end
end
