#!/usr/bin/env ruby

require 'date'
require_relative 'classes/application'
require_relative 'classes/user_input_validator'

def make_date_range(date_array)
  date_range = (Date.parse(date_array[0])..Date.parse(date_array[1]))
  date_range.to_a.sort.map(&:to_s)
end

def date_params
  return [Date.today.to_s] if ARGF.argv.empty?
  # ARGF.argv isn't empty, validate what's in it
  validator = UserInputValidator.new(ARGF.argv)
  if validator.is_user_input_valid?
    return [ARGF.argv[0]] if ARGF.argv.count == 1
    return make_date_range(ARGF.argv.sort) if ARGF.argv.count == 2
  else
    raise(StandardError, 'The user input is not valid. Please try again.')
  end
end

def main
  app = Application.new(date_params)
  app.run

rescue StandardError => e
  puts e.message
end

main
