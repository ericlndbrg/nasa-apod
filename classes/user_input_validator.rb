require 'date'

class UserInputValidator
  attr_reader :user_input

  def initialize(user_input)
    @user_input = user_input
  end

  def is_user_input_valid?
    return false unless valid_count?
    return false unless valid_format.all?
    return false unless valid_date.all?
    true
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
      rescue
        memo << false
    end
  end
end
