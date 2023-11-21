# frozen_string_literal: true

require 'date'
require_relative 'user_input_error'

# validates user input
class UserInputValidator
  def initialize(unvalidated_user_input)
    self.user_input = unvalidated_user_input
  end

  def validate_user_input
    validate_count
    validate_format
    validate_date
    validate_apod_date
  end

  private

  attr_accessor :user_input

  def validate_count
    # user_input should only contain a single element
    raise_validation_error('Only 1 date (YYYY-MM-DD) is allowed.') unless user_input.count == 1
  end

  def validate_format
    # see if user_input is formatted like YYYY-MM-DD
    unless user_input.first.match?(/\d{4}-\d{2}-\d{2}/)
      raise_validation_error("#{user_input.first} is formatted incorrectly. Use YYYY-MM-DD format instead.")
    end
  end

  def validate_date
    # see if the correctly formatted date is a valid date (i.e. not 2023-09-34)
    # strptime returns the created date object upon success, raises exception otherwise
    Date.strptime(user_input.first, '%Y-%m-%d')
  end

  def validate_apod_date
    # APODs exist only for dates between 1995-06-16 and today inclusive
    # see if the user's submitted date is within that range
    soonest_apod_date = Date.new(1995, 6, 16)
    latest_apod_date = Date.today

    unless (soonest_apod_date..latest_apod_date).include?(Date.parse(user_input.first))
      raise_validation_error("#{user_input.first} is an invalid APOD date. Choose a date between #{soonest_apod_date.to_s} and #{latest_apod_date.to_s} inclusive.")
    end
  end

  def raise_validation_error(error_message)
    raise(UserInputError, error_message)
  end
end
