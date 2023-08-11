class ApodUnavailableError < StandardError
  def initialize(message)
    super(message)
  end
end
