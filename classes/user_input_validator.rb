# frozen_string_literal: true

require 'date'

# validates the user input
class UserInputValidator
  attr_reader :user_input

  def initialize(user_input)
    self.user_input = user_input
    self.user_input.push(Date.today.to_s) if user_input.empty?
  end

  def validate_user_input
    validate_format
    validate_date
    validate_count
    validate_apod_date
  end

  private

  attr_writer :user_input

  def validate_format
    # see if the user input is formatted like YYYY-MM-DD
    user_input.each do |string|
      raise_error("#{string} is formatted incorrectly. Use YYYY-MM-DD instead.") unless string.match?(/\d{4}-\d{2}-\d{2}/)
    end
  end

  def validate_date
    # strptime returns the created date object upon success, raises exception otherwise
    user_input.each do |string|
      Date.strptime(string, '%Y-%m-%d')
    rescue Date::Error
      raise_error("#{string} is not a valid date.")
    end
  end

  def validate_count
    # acceptable ways to run the app with user input:
    #   ruby app.rb <date>
    #   ruby app.rb <date> <date>
    raise_error('Only 2 dates are allowed.') unless (1..2).include?(user_input.count)
  end

  def validate_apod_date
    # APODs exist only for dates between 1995-06-16 and today inclusive
    soonest_apod_date = Date.new(1995, 6, 16)
    latest_apod_date = Date.today

    user_input.each do |string|
      raise_error("#{string} is an invalid APOD date. Choose date(s) between 1995-06-16 and today.") unless (soonest_apod_date..latest_apod_date).include?(Date.parse(string))
    end
  end

  def raise_error(error_message)
    raise(DateValidationError, error_message)
  end
end
