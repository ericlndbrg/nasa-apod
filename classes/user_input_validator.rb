# frozen_string_literal: true

require 'date'

# validates the user input
class UserInputValidator
  attr_reader :user_input

  def initialize(user_input)
    @user_input = user_input.sort
    @user_input.push(Date.today.to_s) if self.user_input.empty?
  end

  def validate
    raise(StandardError, 'Too many dates were passed in.') unless valid_count?
    raise(StandardError, 'Invalid date format. Use YYYY-MM-DD.') unless valid_format.all?
    raise(StandardError, 'Invalid date.') unless valid_date.all?
    raise(StandardError, 'Invalid APOD date. Choose date(s) between 1995-06-16 and today.') unless valid_apod_date.all?
  end

  private

  def valid_count?
    # acceptable ways to run the app with user input are:
    #   ruby app.rb <date>
    #   ruby app.rb <date> <date>
    # self.user_input.count should only be 1 or 2
    (1..2).include?(self.user_input.count)
  end

  def valid_format
    # see if the user input is formatted like YYYY-MM-DD
    self.user_input.each_with_object([]) do |string, memo|
      memo << string.match?(/\d{4}-\d{2}-\d{2}/)
    end
  end

  def valid_date
    # strptime returns the created date object upon success, raises exception otherwise
    # I need to put either true or false in the memo, depending on the success of strptime
    self.user_input.each_with_object([]) do |string, memo|
      memo << true if Date.strptime(string, '%Y-%m-%d')
    rescue Date::Error
      memo << false
    end
  end

  def valid_apod_date
    # APODs exist for dates between 1995-06-16 and today inclusive
    soonest_apod_date = Date.new(1995, 6, 16)
    latest_apod_date = Date.today
    self.user_input.each_with_object([]) do |string, memo|
      memo << (soonest_apod_date..latest_apod_date).include?(Date.parse(string))
    end
  end
end
